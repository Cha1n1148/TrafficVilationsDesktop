using System.Data.Entity;
using System.Windows;
using System.Windows.Controls;
using TrafficVilationsDesktop.Model;

namespace TrafficVilationsDesktop.View.VehiclePages
{
    /// <summary>
    /// Логика взаимодействия для MainPage.xaml
    /// </summary>
    public partial class MainPage : Page
    {
        private TrafficViolationsEntities _dbContext;
        private NavigationContext _navigationContext;

        public MainPage(NavigationContext navigationContext)
        {
            InitializeComponent();

            _navigationContext = navigationContext;

            _dbContext = TrafficViolationsEntities.GetContext();

            _dbContext.Vehicles.Load();

            DataGrid_Main.ItemsSource = _dbContext.Vehicles.Local.ToBindingList();
        }

        private void Add_Button_Click(object sender, RoutedEventArgs e)
        {
            _navigationContext.Navigate(new AddEditPage(_navigationContext, null));
        }

        private void Edit_Button_Click(object sender, RoutedEventArgs e)
        {
            var record = DataGrid_Main.SelectedItem as Vehicle;
            if (record == null)
            {
                MessageBox.Show("Запись не выбрана.", "Ошибка!");
            }
            else
            {
                _navigationContext.Navigate(new AddEditPage(_navigationContext, record));
            }
        }

        private void Delete_Button_Click(object sender, RoutedEventArgs e)
        {
            var record = DataGrid_Main.SelectedItem as Vehicle;
            if (record == null)
            {
                MessageBox.Show("Запись не выбрана.", "Ошибка!");
            }
            else
            {
                if (MessageBox.Show("Вы уверены?", "Удаление записи.", MessageBoxButton.OKCancel) == MessageBoxResult.OK)
                {
                    try
                    {
                        _dbContext.Vehicles.Remove(record);
                        _dbContext.SaveChanges();
                    }
                    catch (System.Exception ex)
                    {
                        MessageBox.Show(ex.Message, "Ошибка!");
                    } 
                }
            }
        }
    }
}
