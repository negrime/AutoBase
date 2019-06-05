using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AutoBase;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AutoBase
{
    //класс пациент
    public  class Client
    {
        public Car car;
        protected Random rand = new Random();
        public PictureBox picture { get; set; } //изображение пациента(нужно хранить в классе для очереди)
        public Breakage breakage { get; set; }//вид болезни

        public Client()
        {
            breakage = Breakage.Create(rand.Next(1, 100) * 100, (BreakageType)rand.Next(3));
            bool isPassanger = rand.Next() % 2 == 0;
            if (isPassanger)
                car = new Passanger();
            else
                car = new Truck();
            car.Generate();
        }

    }

    public abstract class Car
    {
        protected Random rand = new Random();
        public int number { get; set; } //номер страхового полиса
        public string brand { get; set; }
        abstract public void Generate();
    }
    // легковой автомобиль 
    public class Passanger : Car
    {
        public bool isAWD { get; set; } // полный привод
        public Passanger() : base() { }
        //рандомная генерация заполнения полей
        public override void Generate()
        {
            number = rand.Next(101, 499);
            isAWD = (rand.Next() % 2 == 0);
            brand = "vaz";//рандомно, для определенности так
        }
    }
    // Грузовой автомобиль
    public class Truck : Car
    {
        public int tonnage { get; set; }// грузоподъемность
        public Truck() : base()
        {}
        //рандомная генерация заполнения полей
        public override void Generate()
        {
            number = rand.Next(500, 1000);
            brand = "vaz";//рандомно
            tonnage = rand.Next(500, 4000);
        }
    }
}
