using System.Data.Entity;
using System.Linq;

namespace TrafficVilationsDesktop.Model
{
    public partial class TrafficViolationsEntities
    {
        private static TrafficViolationsEntities _context;

        public static TrafficViolationsEntities GetContext()
        {
            if (_context == null)
            {
                _context = new TrafficViolationsEntities();
            }

            return _context;
        }

        public void RollBack()
        {
            var changedEntries = _context.ChangeTracker.Entries()
                .Where(x => x.State != EntityState.Unchanged).ToList();

            foreach (var entry in changedEntries)
            {
                switch (entry.State)
                {
                    case EntityState.Modified:
                        entry.CurrentValues.SetValues(entry.OriginalValues);
                        entry.State = EntityState.Unchanged;
                        break;
                    case EntityState.Added:
                        entry.State = EntityState.Detached;
                        break;
                    case EntityState.Deleted:
                        entry.State = EntityState.Unchanged;
                        break;
                }
            }
        }
    }

    public partial class Driver
    {
        public string FullName { get => $"{Last_Name} {First_Name} {Middle_Name}"; }
    }

    public partial class Vehicle
    {
        public string FullNumber { get => $"{Series} {Registration_Number} {Region_Code}"; }
    }
}
