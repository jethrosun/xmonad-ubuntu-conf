import System.Taffybar

import System.Taffybar.Systray
import System.Taffybar.TaffyPager
import System.Taffybar.Pager
import System.Taffybar.Battery
import System.Taffybar.SimpleClock
import System.Taffybar.Widgets.PollingGraph
import System.Taffybar.FreedesktopNotifications
import Graphics.UI.Gtk

import System.Information.CPU

textWidgetNew :: String -> IO Widget
textWidgetNew str = do
    box <- hBoxNew False 0
    label <- labelNew $ Just str
    boxPackStart box label PackNatural 0
    widgetShowAll box
    return $ toWidget box

cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

main = do
    let clock = textClockNew Nothing "<span fgcolor='#bbbbbb'>%-I:%M %p, %A %B %d</span>" 1
        pager = taffyPagerNew defaultPagerConfig
            { widgetSep = " :: "
            , activeWorkspace = colorize "#ffaa00" "" . escape
            , visibleWorkspace = colorize "#aa5500" "" . escape
            --, emptyWorkspace = colorize "#444444" "" . escape
            }
        tray = systrayNew
        sep = textWidgetNew " ::"
        cpuCfg = defaultGraphConfig {
            graphDataColors = [ (1, 0.1, 0.1, 1) ]
          , graphBackgroundColor = (0.1, 0.1, 0.1)
          , graphDirection = RIGHT_TO_LEFT
          , graphPadding = 3
          , graphWidth = 25
          , graphBorderWidth = 0
          , graphLabel = Nothing
        }
        cpu = pollingGraphNew cpuCfg 1 cpuCallback
        battery = batteryBarNew defaultBatteryConfig 10
        batteryTime = textBatteryNew "| $time$" 10
    defaultTaffybar defaultTaffybarConfig
                        { startWidgets = [ pager ]
                        , endWidgets = [ clock, sep, battery, batteryTime, cpu, sep, tray ]
                        }
