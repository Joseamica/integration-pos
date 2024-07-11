
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.IO;
using System.Net.Http;
using System.Threading;
using System.Text;
using System.Xml.Linq;
using ServiceBroker_Consola.Cls;

namespace ServiceBroker
{
    static class Config
    {
        public static Configuration settings()
        {
            StreamReader r = new StreamReader("C:/servicesAvoqado/appsettings.json");
            string jsonString = r.ReadToEnd();
            return JsonConvert.DeserializeObject<Configuration>(jsonString);
        }
    }
    class ServiceBroker 
    {

        
       
        static void Main(string[] args)
        {
            Consumer consumer = new();
            consumer.startConsumer();
        }


        public static void sendOrder(JsondataOrder payload)
        {
            string urlPostOrden = Config.settings().urlPostOrden;
            string venueId = Config.settings().venueId;

            Console.WriteLine(JsonConvert.SerializeObject(payload));
            OrderApi orderApi = new OrderApi();
            orderApi.folio = payload.folio;
            orderApi.mesa = payload.mesa;
            orderApi.venueId = venueId;
            orderApi.new_mesa = payload.new_mesa;
            orderApi.status = payload.status;
            orderApi.impreso = payload.impreso;
            orderApi.change_table = bool.Parse(payload.change_table);

            _ = sendPost(orderApi, urlPostOrden);
        }

        public static void sendProductAsync(JsondataProduct payload)
        {

            string urlPostOrden = Config.settings().urlPostProduct;
            string venueId = Config.settings().venueId;

            ProductApi productApi = new ProductApi();

            productApi.hora = payload.hora;
            productApi.cantidad = payload.cantidad;
            productApi.modificador = payload.modificador;
            productApi.precio = payload.precio;
            productApi.folio = payload.foliodet;
            productApi.mesa = payload.mesa;
            productApi.nombre = payload.nombre;
            productApi.modificador = payload.modificador;
            productApi.movimiento = payload.movimiento;
            productApi.venueId = venueId;
            productApi.operation = "INSERT";

            _ = sendPost(productApi, urlPostOrden);
        }

        static async Task<bool> sendPost(Object obj, string urlPostOrden)
        {
            string json = JsonConvert.SerializeObject(obj);
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                var content = new StringContent(json, Encoding.UTF8, "application/json");
                client.PostAsync(urlPostOrden, content).Wait();
            }
            return true;
        }
    }


    public class Fields
    {
        public string type { get; set; }
        public bool optional { get; set; }
        public string field { get; set; }

    }
    public class Schema
    {
        public string type { get; set; }
        public IList<Fields> fields { get; set; }
        public bool optional { get; set; }

    }
    public class PayloadOrder
    {
        public string jsondata { get; set; }
        public int id { get; set; }

    }

    public class PayloadProduct
    {
        public string jsondata { get; set; }
        public int id { get; set; }

    }


    public class JsondataOrder
    {
        public string folio { get; set; }
        public string mesa { get; set; }
        public string new_mesa { get; set; }
        public string change_table { get; set; }
        public string status { get; set; }
        public string impreso { get; set; }

    }


    public class JsondataProduct
    {
        public string foliodet { get; set; }
        public string orden { get; set; }
        public string movimiento { get; set; }
        public string cantidad { get; set; }
        public string nombre { get; set; }
        public string precio { get; set; }
        public string mesa { get; set; }
        public string hora { get; set; }
        public string modificador { get; set; }
        public string venueId { get; set; }

    }
    public class OrderKafka
    {
        public Schema schema { get; set; }
        public PayloadOrder payload { get; set; }

    }

    public class ProductKafka
    {
        public Schema schema { get; set; }
        public PayloadProduct payload { get; set; }

    }

    public class OrderApi
    {
        public string venueId { get; set; }
        public string folio { get; set; }
        public string mesa { get; set; }
        public string new_mesa { get; set; }
        public string status { get; set; }
        public string impreso { get; set; }
        public bool change_table { get; set; }
    }

    public class ProductApi
    {
        public string venueId { get; set; }
        public string folio { get; set; }
        public string movimiento { get; set; }
        public string cantidad { get; set; }
        public string nombre { get; set; }
        public string precio { get; set; }
        public string mesa { get; set; }
        public string hora { get; set; }
        public string modificador { get; set; }
        public string operation { get; set; }
    }


}
