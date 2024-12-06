using System.Windows;
using TrafficVilationsDesktop.View.MainWindowPages;

namespace TrafficVilationsDesktop
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();

            WindowControl.SetWindow(this);

            Tab_Detailed.Navigate(new DetailedPage());
            Tab_TypeStat.Navigate(new TypeStatPage());

            Tab_DriversMain.Navigate(new View.DriverPages.MainPage(new NavigationContext(Tab_DriversMain)));
            Tab_DriverLecensesMain.Navigate(new View.DriverLicencePages.MainPage(new NavigationContext(Tab_DriverLecensesMain)));
            Tab_VehiclesMain.Navigate(new View.VehiclePages.MainPage(new NavigationContext(Tab_VehiclesMain)));
            Tab_ViolationsMain.Navigate(new View.ViolationPages.MainPage(new NavigationContext(Tab_ViolationsMain)));
            Tab_ViolationTypesMain.Navigate(new View.ViolationTypePages.MainPage(new NavigationContext(Tab_ViolationTypesMain)));
        }
    }
}