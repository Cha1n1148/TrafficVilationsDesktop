using System.Data.Entity;
using System.Windows.Controls;
using TrafficVilationsDesktop.Model;

namespace TrafficVilationsDesktop.View.MainWindowPages
{
    /// <summary>
    /// Логика взаимодействия для TypeStatPage.xaml
    /// </summary>
    public partial class TypeStatPage : Page
    {
        private TrafficViolationsEntities _dbContext;

        public TypeStatPage()
        {
            InitializeComponent();

            _dbContext = TrafficViolationsEntities.GetContext();

            _dbContext.ViolationStatistics.Load();

            DataGrid_Main.ItemsSource = _dbContext.ViolationStatistics.Local.ToBindingList();
        }
    }
}
