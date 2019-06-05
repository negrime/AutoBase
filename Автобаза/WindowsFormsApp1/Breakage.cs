using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AutoBase;
using System.Threading.Tasks;

namespace AutoBase
{
    //вид болезни
    //Surgeon, Dentist, Pediatrician, Traumatologist
    public enum BreakageType {to, razval, wheel }
    //паттерн Singltone
    public abstract class Breakage
    {
        public double price { get; protected set; }
        public BreakageType breakageType { get; set; }
        public abstract List<string> SuccessMessages { get; }
        public abstract List<string> FailMessages { get; }
        public Breakage() { }
        public static  Breakage Create(double price, BreakageType type)
        {
            Breakage t;
            switch (type)
            {
                case BreakageType.to: t = new To(); break;
                case BreakageType.razval: t = new Razval(); break;
                case BreakageType.wheel: t = new Wheel(); break;
                default: throw new Exception("Некорректный тип услуги!");
            }
            t.price = price;
            return t;
        }
    }

    public class To : Breakage
    {
        public To()
        {
            breakageType = BreakageType.to;
        }
        public override List<string> SuccessMessages
        {
            
            get
            {
                return new List<string>
                {
                    "Первичный осмотр автомобиля...",
                    "Проводим техническое обслуживание...",
                    "Пожалуйста, подождите...",
                    "Техническое обслуживание прошло успешно!",
                    string.Format($"Оплата в размере {price} р")
                };
            }
        }

        public override List<string> FailMessages
        {
            get
            {
                return new List<string>
                {
                    "Получение сведений о  пациенте...",
                    "Осмотр горла...",
                    "Проверка дыхания...",
                    "Пациенту следует продлить больничный!"
                };
            }
        }
    }

    public class Razval : Breakage
    {
        public Razval()
        {
            breakageType = BreakageType.razval;
        }
        public override List<string> SuccessMessages
        {
            get
            {
                return new List<string>
                {
                    "Первичный осмотр автомобиля...",
                    "Проводим развал схождения...",
                    "Пожалуйста, подождите...",
                    "Прошло успешно!",
                     string.Format($"Оплата в размере {price} р")
                };
            }
        }

        public override List<string> FailMessages
        {
            get
            {
                return new List<string>
                {
                    "Получение сведений о  пациенте...",
                    "Осмотр горла...",
                    "Проверка дыхания...",
                    "Пациенту следует продлить больничный!"
                };
            }
        }
    }

    public class Wheel : Breakage
    {
        public Wheel()
        {
            breakageType = BreakageType.wheel;
        }
        public override List<string> SuccessMessages
        {
            get
            {
                return new List<string>
                {
                    "Первичный осмотр автомобиля...",
                    "Проводим замену колеса...",
                    "Пожалуйста, подождите...",
                    "Прошло успешно!",
                    string.Format($"Оплата в размере {price} р")
                };
            }
        }

        public override List<string> FailMessages
        {
            get
            {
                return new List<string>
                {
                    "Получение сведений о  пациенте...",
                    "Осмотр горла...",
                    "Проверка дыхания...",
                    "Пациенту следует продлить больничный!"
                };
            }
        }
    }
}
