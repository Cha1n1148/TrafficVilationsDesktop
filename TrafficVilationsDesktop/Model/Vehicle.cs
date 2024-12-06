//------------------------------------------------------------------------------
// <auto-generated>
//     Этот код создан по шаблону.
//
//     Изменения, вносимые в этот файл вручную, могут привести к непредвиденной работе приложения.
//     Изменения, вносимые в этот файл вручную, будут перезаписаны при повторном создании кода.
// </auto-generated>
//------------------------------------------------------------------------------

namespace TrafficVilationsDesktop.Model
{
    using System;
    using System.Collections.Generic;
    
    public partial class Vehicle
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Vehicle()
        {
            this.Violations = new HashSet<Violation>();
        }
    
        public int Vehicle_ID { get; set; }
        public int Driver_ID { get; set; }
        public string Series { get; set; }
        public int Registration_Number { get; set; }
        public int Region_Code { get; set; }
        public string Brand { get; set; }
        public string Model { get; set; }
        public Nullable<int> Year { get; set; }
    
        public virtual Driver Driver { get; set; }
        public virtual Driver Driver1 { get; set; }
        public virtual Region Region { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Violation> Violations { get; set; }
    }
}