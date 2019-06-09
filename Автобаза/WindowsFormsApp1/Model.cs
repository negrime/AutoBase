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
        public event EventHandler OnSetImage;

        public event EventHandler OnPrintState;

        public event EventHandler OnMove;

        public event EventHandler OnReverse;

        public event EventHandler OnReverseBack;

        public List<Client> clients; //список клиентов
        private List<Thread> threads; //список потоков клиентов
        private ManualResetEvent mreReg, mreRef; 
        private int LastRight;
        private int ind;

        public Model()
        {
            mreReg = new ManualResetEvent(true);
            mreRef = new ManualResetEvent(true);
            threads = new List<Thread>();
            clients = new List<Client>();
            LastRight = 20;
            ind = -1;
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
            Client client = AddClient();
            int num = clients.IndexOf(client);
            bool IsRegistrated = false;
            int finalX;
            lock ((object)LastRight)
            {
                LastRight += 90;
                Move(num, LastRight, 435, 7); //cтавим в конец
                mreReg.WaitOne();   //ждет пока первый не уйдет
                while (!IsRegistrated)
                {
                    mreReg.WaitOne();
                    if (client.picture.Location.X <= 90)   //если он первый
                    {
                        mreReg.Reset();
                        LastRight -= 90;
                        //блокируем остальные потоки если клиент стоит первым
                     ///  Thread.Sleep(1000);     //5000    
                        IsRegistrated = true;
                    }
                    else
                    {
                        mreReg.WaitOne();
                        Move(num, client.picture.Location.X - 7, 435, 7);
                    }
                }

                switch ((int)client.breakage.breakageType)
                {
                    case 0:
                        finalX = 90;
                        break;
                    case 1:
                        finalX = 265;
                        Reverse(num);
                        break;
                    case 2:
                        finalX = 430;
                        Reverse(num);
                        break;
                    case 3:
                        finalX = 597;
                        Reverse(num);
                        break;
                    default:
                        finalX = 90;
                        break;

                }
                Move(num, finalX, 130, 7);
            }
            
            mreReg.Set();//запускаем движение очереди 
            //заходим в сервис(поднимаемся вверх)
            Move(num, finalX, 50, 7);
            //и налево
            Move(num, finalX - 65, 50, 7);
            Reverse(num);
            Random rand = new Random();
            int period = rand.Next(1500, 4000);
            bool success = rand.Next() % 2 == 0;
            List<string> messages = new List<string>();
            messages = success ? client.breakage.SuccessMessages : client.breakage.FailMessages;
            Thread.Sleep(period);
            PrintState(num, messages);
  
            // Отправляем в закат
            Move(num, 1200, 350, 7);

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
