﻿using System.Windows;
using System.Windows.Controls;
using TrafficVilationsDesktop.Model;

namespace TrafficVilationsDesktop.View.DriverPages
{
    /// <summary>
    /// Логика взаимодействия для AddEditPage.xaml
    /// </summary>
    public partial class AddEditPage : Page
    {
        private TrafficViolationsEntities _dbContext;
        private NavigationContext _navigationContext;

        private AddEditMode _addEditMode;
        private string _title = "Водителе";

        private Driver _record;

        public AddEditPage(NavigationContext navigationContext, Driver record)
        {
            InitializeComponent();

            _dbContext = TrafficViolationsEntities.GetContext();
            _navigationContext = navigationContext;

            if (record == null)
            {
                _addEditMode = AddEditMode.Add;
                _record = new Driver();
                WindowControl.SetTitle("Добавление записи о " + _title);
            }
            else
            {
                _addEditMode = AddEditMode.Edit;
                _record = record;
                WindowControl.SetTitle("Изменение записи о " + _title);
            }

            DataContext = _record;
        }

        private void OK_Button_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            try
            {
                switch (_addEditMode)
                {
                    case AddEditMode.Add:
                        _dbContext.Drivers.Add(_record);
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
