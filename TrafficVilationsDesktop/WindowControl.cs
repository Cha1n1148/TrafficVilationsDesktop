using System.Windows;

namespace TrafficVilationsDesktop
{
    public static class WindowControl
    {
        private static Window _window;

        public static void SetWindow( Window window )
        {
            _window = window;
        }

        public static void SetTitle(string newTitle)
        {
            _window.Title = newTitle;
        }

        public static void ResetTitle()
        {
            _window.Title = "Учёт нарушений ПДД";
        }
    }
}
