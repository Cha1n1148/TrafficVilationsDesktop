using System.Data.Entity;
using System.Windows;
using System.Windows.Controls;
using TrafficVilationsDesktop.Model;

namespace TrafficVilationsDesktop.View.VehiclePages
{
    /// <summary>
    /// Логика взаимодействия для AddEditPage.xaml
    /// </summary>
    public partial class AddEditPage : Page
    {
        private TrafficViolationsEntities _dbContext;
        private NavigationContext _navigationContext;

        private AddEditMode _addEditMode;
        private string _title = "Транпортном средстве";

        private Vehicle _record;

        public AddEditPage(NavigationContext navigationContext, Vehicle record)
        {
            InitializeComponent();

            _dbContext = TrafficViolationsEntities.GetContext();
            _navigationContext = navigationContext;

            if (record == null)
            {
                _addEditMode = AddEditMode.Add;
                _record = new Vehicle();
                WindowControl.SetTitle("Добавление записи о " + _title);
            }
            else
            {
                _addEditMode = AddEditMode.Edit;
                _record = record;
                WindowControl.SetTitle("Изменение записи о " + _title);
            }

            _dbContext.Drivers.Load();
            Drivers.ItemsSource=_dbContext.Drivers.Local.ToBindingList();

            _dbContext.Regions.Load();
            Regions.ItemsSource=_dbContext.Regions.Local.ToBindingList();

            DataContext = _record;
        }

        private void OK_Button_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            try
            {
                switch (_addEditMode)
                {
                    case AddEditMode.Add:
                        _dbContext.Vehicles.Add(_record);
                        break;
                    case AddEditMode.Edit:
                        break;
                }

                _dbContext.SaveChanges();

                MessageBox.Show("Успешно!");

                _navigationContext.Back();
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message + "\n" + ex.InnerException, "Ошибка!");
            }
        }

        private void Cancel_Button_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            _dbContext.RollBack();
            _navigationContext.Back();
        }
    }
}
