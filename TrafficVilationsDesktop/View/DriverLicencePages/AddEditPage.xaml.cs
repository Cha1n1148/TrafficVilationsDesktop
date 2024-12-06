using System.Data.Entity;
using System.Windows;
using System.Windows.Controls;
using TrafficVilationsDesktop.Model;

namespace TrafficVilationsDesktop.View.DriverLicencePages
{
    /// <summary>
    /// Логика взаимодействия для AddEditPage.xaml
    /// </summary>
    public partial class AddEditPage : Page
    {
        private TrafficViolationsEntities _dbContext;
        private NavigationContext _navigationContext;

        private AddEditMode _addEditMode;
        private string _title = "Водительских правах";

        private Driver_Licenses _record;

        public AddEditPage(NavigationContext navigationContext, Driver_Licenses record)
        {
            InitializeComponent();

            _dbContext = TrafficViolationsEntities.GetContext();
            _navigationContext = navigationContext;

            if(record == null)
            {
                _addEditMode = AddEditMode.Add;
                _record = new Driver_Licenses();
                WindowControl.SetTitle("Добавление записи о " + _title);
            }
            else
            {
                _addEditMode = AddEditMode.Edit;
                _record = record;
                WindowControl.SetTitle("Изменение записи о " + _title);
            }

            _dbContext.Drivers.Load();
            Drivers.ItemsSource = _dbContext.Drivers.Local.ToBindingList();
            _dbContext.Driver_License_Category.Load();
            Categories.ItemsSource = _dbContext.Driver_License_Category.Local.ToBindingList();
            
            DataContext = _record;
        }

        private void OK_Button_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            try
            {
                switch (_addEditMode)
                {
                    case AddEditMode.Add:
                        _dbContext.Driver_Licenses.Add(_record);
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
