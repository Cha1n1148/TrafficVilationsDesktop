using System.Linq;
using System.Windows;
using System.Windows.Controls;
using TrafficVilationsDesktop.Model;

namespace TrafficVilationsDesktop.View.DriverPages
{
    /// <summary>
    /// Логика взаимодействия для DriverDetailsPage.xaml
    /// </summary>
    public partial class DetailsPage : Page
    {
        private TrafficViolationsEntities _dbContext;
        private NavigationContext _navigationContext;

        public DetailsPage(NavigationContext navigationContext, Driver record)
        {
            InitializeComponent();

            _dbContext = TrafficViolationsEntities.GetContext();
            _navigationContext = navigationContext;

            DataGrid_Licenses.ItemsSource = record.Driver_Licenses.ToList();
            DataGrid_Vehicles.ItemsSource = record.Vehicles.ToList();
            DataGrid_Violations.ItemsSource = record.Violations.ToList();

            DataContext = record;
        }

        private void BackButton_Click(object sender, RoutedEventArgs e)
        {
            _navigationContext.Back();
        }
    }
}
