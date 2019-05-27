using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Threading;
using System.Drawing;


namespace lab2
{
    internal class Controller
    {
        private List<PictureBox> _carsPics = new List<PictureBox>();
        private Panel _panel;
        private ListBox _messageBox; // список очереди и сообщений
        private Model _m;
        private ManualResetEvent _mre;

        internal Controller(Panel panel, ListBox messageBox)
        {
            _panel = panel;
            _messageBox = messageBox;
            _mre = new ManualResetEvent(false);
            _mre.Set();
            _m = new Model();


        }

        // Возобновление фонового потока
        internal void Start()
        {
            _mre.Set();
        }

        // Приостановка потоков
        internal void Stop()
        {
            _mre.Reset();

        }
        // Приостановка потоков
        internal void Exit()
        {
            _m.Exit();
        }

        //добавление клиента
        internal void Add()
        {
            _m.AddCar();
            _m.AddStart();
        }

        //движение объекта как такового
        public void MovePatient(PictureBox picture, int finalX, int finalY, int Delay)
        {
            int x = picture.Location.X, y = picture.Location.Y;
            while (x != finalX || y != finalY)
            {
                _mre.WaitOne();
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

        // Создание картинки для пациента
        private void NewPicture(object sender, EventArgs args)
        {
            PatientImageEventArgs imgArgs = (PatientImageEventArgs)args;
            Car patient = _m.cars[imgArgs.num];
            PictureBox img = new PictureBox();
            if (patient is Truck)
            {
                //    img.Image = lab2.Properties.Resources.man;
                img.Image = lab2.Properties.Resources.car;
            }
            else
            { img.Image = lab2.Properties.Resources.car; }

            PictureBox box = new PictureBox
            {
                Size = new Size(69, 65),
                Visible = true,
                Image = img.Image,
                Location = new Point(1300, 435),
                SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom
            };
            _panel.Invoke((Action)(() => _panel.Controls.Add(box)));
            _m.cars[imgArgs.num].picture = box;
            _carsPics.Add(box);
        }
    }
}
