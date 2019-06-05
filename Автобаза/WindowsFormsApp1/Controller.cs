using System;
using System.Collections.Generic;
using System.Drawing;
using System.Threading;
using System.Windows.Forms;

namespace AutoBase
{
    internal class Controller
    {
        private static Controller instance;

        private List<PictureBox> clientPics = new List<PictureBox>();
        private Panel panel; // Панель модели
        private ListBox messageBox; // Список очереди и сообщений
        private Model m;
        private ManualResetEvent mre;
        // Конструктор
        internal Controller(Panel _panel, ListBox _messageBox)
        {
            panel = _panel;
            messageBox = _messageBox;
            mre = new ManualResetEvent(false);
            mre.Set();
            m = new Model();
            m.OnMove += Move;

            m.OnPrintState += PrintState;
            m.OnReverse += NewBitMap;
            m.OnSetImage += NewPicture;
    
        }

        public static Controller getInstance(Panel panel, ListBox ls)
        {
            if (instance == null)
                instance = new Controller(panel, ls);
            return instance;
        }

        // Возобновление фонового потока
        internal void Start()
        {
            mre.Set();
        }

        // Приостановка потоков
        internal void Stop()
        {
            mre.Reset();
           
        }
        // Приостановка потоков
        internal void Exit()
        {
            m.Exit();
        }

        //добавление клиента
        internal void Add()
        {
            m.AddPatient();
            m.AddStart();  
        }
        
        //движение объекта как такового
        public void MoveClient(PictureBox picture, int finalX, int finalY, int Delay)
        {
            int x = picture.Location.X, y = picture.Location.Y;
            while (x != finalX || y != finalY)
            {
                mre.WaitOne();
                if (x < finalX)
                    x++;
                if (x > finalX)
                    x--;
                if (y < finalY)
                    y++;
                if (y > finalY)
                    y--;
                picture.BeginInvoke((Action)(() => picture.Location = new Point(x, y)));
                Thread.Sleep(Delay);
            }
        }

        // Создание картинки для клиента
        private  void NewPicture(object sender, EventArgs args)
        {
            PatientImageEventArgs imgArgs = (PatientImageEventArgs)args;
            Client patient = m.patients[imgArgs.num];
            PictureBox img=new PictureBox();
            if (patient.car is Truck)
            {
               img.Image = AutoBase.Properties.Resources.truck;
            }
            else
            { img.Image = AutoBase.Properties.Resources.passanger; }

            PictureBox box = new PictureBox
            {
                Size = new Size(89, 85),
                Visible = true,
                Image=img.Image,
                Location = new Point(1300, 435),
                SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom
            };
            panel.Invoke((Action)(() => panel.Controls.Add(box)));
            m.patients[imgArgs.num].picture = box;
            clientPics.Add(box);
        }

        //движение клиентов
        private void Move(object sender, EventArgs args)
        {
            MoveEventArgs moveArgs = (MoveEventArgs)args;
            PictureBox pic = clientPics[moveArgs.who];
            MoveClient(pic, moveArgs.final_x, moveArgs.final_y, moveArgs.del);
        }
        //логирование
        private void PrintState(object sender, EventArgs args)
        {
            StateEventArgs stateArgs = (StateEventArgs)args;
            foreach (string s in stateArgs.stateMessage)
            {
                mre.WaitOne();
                messageBox.Invoke((Action)(() => messageBox.Items.Add(s)));
                Thread.Sleep(500);
            }
        }
        //переворачиваем картинку
        private  void NewBitMap(object sender, EventArgs args)
        {
            PatientImageEventArgs imgArgs = (PatientImageEventArgs)args;
            Bitmap img;
            Client client = m.patients[imgArgs.num];
            if (client.car is Truck)
            {
               img = AutoBase.Properties.Resources.truck ;
            }
            else
            {
                img = AutoBase.Properties.Resources.passanger;
            }
            img.RotateFlip(RotateFlipType.Rotate180FlipY);
            client.picture.Image = img;
        }


    }
}
