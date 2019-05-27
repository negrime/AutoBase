using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace lab2
{
    public abstract class Car
    {
        public string[] brands = new string[] {"zhiguli", "toyota" };
        public int number { get; set; } // номер машины
        public string brand { get; set; } // марка машины 
        public Breakage breakage { get; set; } // вид поломки
        public PictureBox picture { get; set; } // изображение машины
        protected Random rand = new Random();

        public Car()
        {
            number = rand.Next(100, 999);
        }
        abstract public void Generate();
    }

    public class Passanger : Car
    {
        public bool isAwd { get; set; } // полный привод
        public Passanger() : base()
        {
            breakage = null;
        }

        public override void Generate()
        {
            isAwd = rand.Next() % 2 == 0;
            brand = brands[rand.Next(0, brands.Length)];
            breakage = Breakage.Create((BreakageType)rand.Next(2));
        }

    }

    public class Truck : Car
    {
        public int tonnage { get; set; } // вместимость
        public Truck() : base()
        {
            breakage = null;
        }

        public override void Generate()
        {
            tonnage = rand.Next(500, 4000);
            brand = brands[rand.Next(0, brands.Length)];
            breakage = Breakage.Create((BreakageType)rand.Next(2));
        }
    }
}
