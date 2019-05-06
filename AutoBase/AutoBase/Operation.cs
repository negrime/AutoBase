using System;
using System.Collections.Generic;

namespace AutoBase
{
    public enum OperationType { Deposit, Withdraw, Transfer }

    public abstract class Operation
    {
        public double Amount { get; protected set; }
        public abstract List<string> SuccessMessages { get; }
        public abstract List<string> FailMessages { get; }

        public static Operation Create(double amount, OperationType type)
        {
            Operation t;

            switch (type)
            {
                case OperationType.Deposit: t = new ElectricityOperation(); break;
                case OperationType.Withdraw: t = new OilOperation(); break;
                case OperationType.Transfer: t = new RazvalOperation(); break;
                default: throw new Exception("Некорректный тип операций");
            }

            t.Amount = amount;
            return t;
        }
    }

    public class ElectricityOperation : Operation
    {
        public override List<string> SuccessMessages
        {
            get
            {
                return new List<string>
                {
                    "Получение сведений о транспорте",
                    "Проверка транспорта",
                    string.Format("За починку проводки было отдано {0} р", Amount),
                    "ТО автомобиля прошло успешно"
                };
            }
        }

        public override List<string> FailMessages
        {
            get
            {
                return new List<string>
                {
                    "Получение сведений о транспорте",
                    "Проверка транспорта",
                    "ТО не завершено: неполадки не удалось устранить"
                };
            }
        }
    }

    public class OilOperation : Operation
    {
        public override List<string> SuccessMessages
        {
            get
            {
                return new List<string>
                {
                    "Получение сведений о транспорте",
                    "Проверка транспорта",
                    string.Format("За починку бензонасоса было вычтено {0} р", Amount),
                    "ТО автомобиля прошло успешно"
                };
            }
        }

        public override List<string> FailMessages
        {
            get
            {
                return new List<string>
                {
                    "Получение сведений о транспорте",
                    "Проверка транспорта",
                    "ТО не завершено: на автобазе нету нужных запчастей"
                };
            }
        }
    }

    public class RazvalOperation : Operation
    {
        public override List<string> SuccessMessages
        {
            get
            {
                return new List<string>
                {
                    "Получение сведений о транспорте",
                    "Проверка транспорта",
                    "Проверка развал-схождения",
                    string.Format("За полный осмотр автомобиля отдано {0} р", Amount),
                    "ТО автомобиля прошло успешно"
                };
            }
        }

        public override List<string> FailMessages
        {
            get
            {
                return new List<string>
                {
                    "Получение сведений о транспорте",
                    "Проверка транспорта",
                    "ТО не завершено: механиков не было на работе"
                };
            }
        }
    }
}