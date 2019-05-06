using System;
using System.Collections.Generic;

namespace AutoBase
{
    public enum Auto { vehicle, coach }

    public class Client
    {
        public int Number { get; private set; }
        public Auto AutoType { get; private set; }
        public Operation Operation { get; private set; }

        private Client() { }

        private static bool initialized = false;
        private static Random rand;
        public static int NextNumber { get; private set; }

        public static void Initialize()
        {
            if (initialized) return;

            rand = new Random((int)(DateTime.Now.Ticks % int.MaxValue));
            NextNumber = 101;
            initialized = true;
        }

        public static Client Create(int num, Auto avtotype, int amount, OperationType type)
        {
            var client = new Client { Number = num, AutoType = avtotype };
            client.Operation = Operation.Create(amount, type);

            return client;
        }

        public static Client CreateRandom()
        {
            var number = NextNumber++;
            var avtotype = (Auto)rand.Next(2);
            var amount = rand.Next(1, 100) * 500;
            var type = (OperationType)rand.Next(3);

            return Create(number, avtotype, amount, type);
        }
    }
}