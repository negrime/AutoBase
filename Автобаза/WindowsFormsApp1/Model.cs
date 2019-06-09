using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace AutoBase
{
    //для движения клиентов
    class MoveEventArgs : EventArgs
    {
        public int who { get; }
        public int final_x { get; }
        public int final_y { get; }
        public int del { get; }

        public MoveEventArgs(int _who, int _final_x, int _final_y, int _del)
        {
            who = _who;
            final_x = _final_x;
            final_y = _final_y;
            del = _del;
        }
    }

    //для создания изображения
    class PatientImageEventArgs : EventArgs
    {
        public int num { get; }
        public PatientImageEventArgs( int _num)
        {
            num = _num;
        }
    }
    //для вывода комментариев
    class StateEventArgs : EventArgs
    {
        public int num { get; }
        public List<string> stateMessage { get; }
        public StateEventArgs(int _num, List<string> txt)
        {
            num = _num;
            stateMessage = txt;
        }
    }

    class Model
    {
        private static Model model;
        public event EventHandler OnSetImage;

        public event EventHandler OnPrintState;

        public event EventHandler OnMove;

        public event EventHandler OnReverse;

        public event EventHandler OnReverseBack;

        public List<Client> clients; //список клиентов
        private List<Thread> threads; //список потоков клиентов
        private ManualResetEvent mreReg; 
        private int ind;

        public Model()
        {
            mreReg = new ManualResetEvent(true);
            threads = new List<Thread>();
            clients = new List<Client>();
            LastRight = 80;
            ind = -1;
        }
       
        public static Model GetModel()
        {
            if (model == null)
                model = new Model();
            return model;
        }
        public void Exit()
        {
            foreach (Thread t in threads)
                try
                {
                    t.Abort();
                }
                catch (Exception) { }
        }

        public void Reverse(int num)
        {
            OnReverse?.Invoke(this, new PatientImageEventArgs(num));
        }
        public void ReverseBack(int num)
        {
            OnReverseBack?.Invoke(this, new PatientImageEventArgs(num));
        }

        internal Client AddClient()
        {
            ind++;
            Client client = new Client();
            clients.Add(client);
            SetImage(ind);
            return client;
        }

        internal void AddStart()
        {
            Thread thread = new Thread(Work);
            threads.Add(thread);
            thread.Start();
        }

        public void SetImage(int ind)
        {
            OnSetImage?.Invoke(this, new PatientImageEventArgs(ind));
        }

        public void Move(int _who ,int _final_x, int _final_y, int _del)
        {
            OnMove?.Invoke(this, new MoveEventArgs(_who,_final_x, _final_y, _del));
        }
        
        public void Work()
        {
            Controller.instance.Work();

        }

        public void PrintState(int num, List<string> messages)
        {
            OnPrintState?.Invoke(this, new StateEventArgs(num,CurrentState(num, messages)));
        }

        private List<string>  CurrentState(int num,List<string> messages)
        {
            List<string> strMes = new List<string>();
            foreach (string s in messages)
            {
                strMes.Add(string.Format("Номер автомобиля: {0}: {1}", clients[num].car.number, s));
            };
            return strMes;
        }
        
    }


   
}
