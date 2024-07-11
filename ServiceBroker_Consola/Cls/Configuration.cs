using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServiceBroker
{
    public class Configuration
    {
        public string connectionString { get; set; }
        public string tableOrder { get; set; }
        public string tableProduc { get; set; }
        public string urlPostOrden { get; set; }
        public string urlPostProduct { get; set; }
        public string venueId { get; set; }

    }
}
