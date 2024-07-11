
using Newtonsoft.Json;
using ServiceBroker_Consola.Cls;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;


namespace ServiceBroker
{
    internal class Consumer
    {
        public Consumer()
        {

        }

        public void startConsumer()
        {
            //Console.WriteLine("Create Task");
            Task task1 = Task.Run(delegate
            {
                startServiceOrder();
            });
            
            Task task2 = Task.Run(delegate
            {
                startServiceProduct();
            });

            Task.WaitAll(task1, task2);


        }

        public void startServiceOrder()
        {
            
            try
            {
                AccesoDatos.cadenaConexion =@""+Config.settings().connectionString;
                System.Data.DataTable dt = AccesoDatos.GetTmpDataTable("SELECT Jsondata,id FROM dbo.InvokeApiAfterOrderLog WITH (NOLOCK) WHERE IsSuccess = 0 ");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    var jsondataOrder = JsonConvert.DeserializeObject<JsondataOrder>((string)dt.Rows[i]["Jsondata"]);
                    ServiceBroker.sendOrder(jsondataOrder);
                    //AccesoDatos.UpdateTmpDataTable("UPDATE dbo.InvokeApiAfterOrderLog SET IsSuccess = 1  WHERE id = " + dt.Rows[i]["id"]);
                }
                //AccesoDatos.UpdateTmpDataTable("UPDATE dbo.InvokeApiAfterOrderLog SET IsSuccess = 1  WHERE IsSuccess = 0");

            }
            catch (SqlException ex)
            {
                Console.WriteLine("Error: {0}", ex.Message); // Esto mostrará el mensaje SqlException
            }

        }

        public void startServiceProduct()
        {
           
            try
            {
                 AccesoDatos.cadenaConexion = @"" + Config.settings().connectionString;
                System.Data.DataTable dt = AccesoDatos.GetTmpDataTable("SELECT Jsondata,id FROM dbo.InvokeApiAfterProductLog WITH (NOLOCK) WHERE IsSuccess = 0");

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    var jsondataProduct = JsonConvert.DeserializeObject<JsondataProduct>((string)dt.Rows[i]["Jsondata"]);
                    ServiceBroker.sendProductAsync(jsondataProduct);
                    //AccesoDatos.UpdateTmpDataTable("UPDATE dbo.InvokeApiAfterProductLog SET IsSuccess = 1  WHERE id = " + dt.Rows[i]["id"]);
                }

            }
            catch (Exception)
            {
                Console.WriteLine("ERRORRRRRRRRRRR");
                throw;
            }

        }
    }
}
