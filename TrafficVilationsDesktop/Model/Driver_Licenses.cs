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
    
    public partial class Driver_Licenses
    {
        public string License_Number { get; set; }
        public int Driver_ID { get; set; }
        public string Category_ID { get; set; }
        public System.DateTime Issue_Date { get; set; }
        public System.DateTime Expiry_Date { get; set; }
    
        public virtual Driver_License_Category Driver_License_Category { get; set; }
        public virtual Driver Driver { get; set; }
        public virtual Driver Driver1 { get; set; }
    }
}
