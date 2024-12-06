using System.Data.Entity;
using System.Windows.Controls;
using TrafficVilationsDesktop.Model;

namespace TrafficVilationsDesktop.View.MainWindowPages
{
    /// <summary>
    /// Логика взаимодействия для DetailedPage.xaml
    /// </summary>
    public partial class DetailedPage : Page
    {
        private TrafficViolationsEntities _dbContext;

        public DetailedPage()
        {
            InitializeComponent();

            _dbContext = TrafficViolationsEntities.GetContext();

            _dbContext.DetailedViolationsInfoes.Load();

            DataGrid_Main.ItemsSource = _dbContext.DetailedViolationsInfoes.Local.ToBindingList();
        }
    }
}
