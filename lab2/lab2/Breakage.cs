using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace lab2
{
    public enum BreakageType { wheel, motor, transmission }
    public abstract class Breakage
    {
        public BreakageType breakageType { get; set; }
        public abstract List<string> SuccessMessages { get; }
        public abstract List<string> FailMessages { get; }
        public Breakage() { }
        public static Breakage Create(BreakageType type)
        {
            Breakage t;
            switch (type)
            {
                case BreakageType.wheel: t = new WheelBreakage(); break;
                case BreakageType.motor: t = new MotorBreakage(); break;
                case BreakageType.transmission: t = new TransmissionBreakage(); break;
                default: throw new Exception("Неккоректный тип поломки");
            }

            return t;
        }
    }

    public class WheelBreakage : Breakage
    {
        public WheelBreakage()
        {
            breakageType = BreakageType.wheel;
        }

        public override List<string> SuccessMessages
        {
            get
            {
                return new List<string>
                {
                    "Диагностика автомобиля...",
                    "Осмотр колес...",
                    "Проверка...",
                    "Колеса в порядке!"
                };
            }
        }

        public override List<string> FailMessages
        {
            get
            {
                return new List<string>
                {
                    "Диагностика автомобиля...",
                    "Осмотр колес...",
                    "Проверка...",
                    "Обнаружена поломка!"
                };
            }
        }
    }

    public class MotorBreakage : Breakage
    {
        public MotorBreakage()
        {
            breakageType = BreakageType.motor;
        }

        public override List<string> SuccessMessages
        {
            get
            {
                return new List<string>
                {
                    "Диагностика автомобиля...",
                    "Осмотр мотора...",
                    "Проверка...",
                    "мотор в порядке!"
                };
            }
        }

        public override List<string> FailMessages
        {
            get
            {
                return new List<string>
                {
                    "Диагностика автомобиля...",
                    "Осмотр мотора...",
                    "Проверка...",
                    "Обнаружена поломка!"
                };
            }
        }
    }

    public class TransmissionBreakage : Breakage
    {
        public TransmissionBreakage()
        {
            breakageType = BreakageType.transmission;
        }

        public override List<string> SuccessMessages
        {
            get
            {
                return new List<string>
                {
                    "Диагностика автомобиля...",
                    "Осмотр коробки передач...",
                    "Проверка...",
                    "все в порядке!"
                };
            }
        }

        public override List<string> FailMessages
        {
            get
            {
                return new List<string>
                {
                    "Диагностика автомобиля...",
                    "Осмотр коробки передач...",
                    "Проверка...",
                    "Обнаружена поломка!"
                };
            }
        }
    }



}
