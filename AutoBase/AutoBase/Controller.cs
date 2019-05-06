//Тех обслуживание: типы операций,клиенты. Смоделировать процесс обслуживания клиентов.

using System;
using System.Collections.Generic;
using System.Drawing;
using System.Threading;

using Panel = System.Windows.Forms.Panel;
using ListBox = System.Windows.Forms.ListBox;
using PictureBox = System.Windows.Forms.PictureBox;

namespace AutoBase
{
    // Связывание картинки и данных клиента
    using RealClient = KeyValuePair<Client, PictureBox>;

    internal class Controller
    {
        private Panel panel; // Панель модели
        private ListBox queueBox, messageBox; // Список очереди и сообщений

        private Timer timer; // Таймер для движения очереди
        private Thread thread; // Фоновый поток (вызывает клиентов к окнам и запускает движение очереди)
        private ManualResetEvent mre; // Приостанавливает работу потока по требованию пользователя

        private List<RealClient> queue; // Непосредственно очередь клиентов
        private Employee A, B, C; // Окна

        // Конструктор
        internal Controller(Panel _panel, ListBox _queueBox, ListBox _messageBox)
        {
            panel = _panel;
            queueBox = _queueBox;
            messageBox = _messageBox;

            queue = new List<RealClient>();
            mre = new ManualResetEvent(false);
            timer = new Timer(MoveQueue, null, Timeout.Infinite, Timeout.Infinite);
            thread = new Thread(Background) { IsBackground = true };

            thread.Start();
        }

        // Возобновление фонового потока
        internal void Start()
        {
            mre.Set();
        }
        // Приостановка фонового потока
        internal void Stop()
        {
            mre.Reset();
        }

        // Добавление нового клиента
        internal void Add()
        {
            var client = Client.CreateRandom();
            var picture = NewPicture(client.AutoType);
            var real = new RealClient(client, picture);

            queue.Add(real);
            panel.Controls.Add(picture);
            timer.Change(0, 10);
            RefreshQueue();
        }
        // Основной метод фонового потока
        private void Background()
        {
            bool mustRefresh = false;
            while (true)
            {
                mre.WaitOne();

                // Вызов клиентов, если автобазы свободны
                if ((A == null || A.Finished) && queue.Count > 0) { A = Call(new Point(12, 84)); mustRefresh = true; }
                if ((B == null || B.Finished) && queue.Count > 0) { B = Call(new Point(136, 84)); mustRefresh = true; }
                if ((C == null || C.Finished) && queue.Count > 0) { C = Call(new Point(256, 84)); mustRefresh = true; }

                if (mustRefresh)
                {
                    i = 0;
                    timer.Change(0, 10);
                    queueBox.Invoke((Action)RefreshQueue);
                    mustRefresh = false;
                }
            }
        }

        // Вызов клиента
        private Employee Call(Point destination)
        {
            var client = queue[0];
            queue.Remove(client);

            var emp = new Employee(client, destination, messageBox, RefreshQueue);
            emp.StartMoving();

            queueBox.Invoke((Action)RefreshQueue);
            return emp;
        }

        // Создание картинки для автомобиля
        private static PictureBox NewPicture(Auto AutoType)
        {
            var box = new PictureBox
            {
                Size = new Size(69, 65),
                Location = new Point(350, 244),
                Image = AutoType == Auto.vehicle ? BankService.Properties.Resources.car : BankService.Properties.Resources.bus,
                SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom
            };

            return box;
        }

        // Обновление списка очереди
        private void RefreshQueue()
        {
            
            queueBox.Items.Clear();

            if (A != null && A.Awaiting) queueBox.Items.Add(string.Format("{0} - {1}", A.ClientNumber, 1));
            if (B != null && B.Awaiting) queueBox.Items.Add(string.Format("{0} - {1}", B.ClientNumber, 2));
            if (C != null && C.Awaiting) queueBox.Items.Add(string.Format("{0} - {1}", C.ClientNumber, 3));
            foreach (var client in queue) queueBox.Items.Add(client.Key.Number);
        }

        // Движение очереди
        private int i;
        private void MoveQueue(object _)
        {
            if (i >= 0 && i < queue.Count)
            {
                var cur = queue[i].Value;
                int x = cur.Location.X, y = cur.Location.Y;
                int X = i > 0 ? queue[i - 1].Value.Location.X + queue[i - 1].Value.Width : 12;

                if (x < X) x++;
                if (x > X) x--;
                else { i++; return; }

                if (cur.InvokeRequired) cur.Invoke((Action)(() => cur.Location = new Point(x, y)));
                else cur.Location = new Point(x, y);
            }
            else
            {
                timer.Change(Timeout.Infinite, Timeout.Infinite);
                i = 0;
            }
        }

        // Работа с автомобилем с момента вызова
        private class Employee
        {
            private Client client;      // Данные клиента
            private PictureBox picture; // Картинка автомобиля
            private ListBox messageBox; // Список очереди
            private Point destination;  // Место клиента перед автобазой
            private Timer timer;
            private Action refreshQueue; // Метод обновления списка очереди (из класса Controller)

            private static Random rand;

            private List<string> messages; // Список сообщений
            private int current; // Номер сообщения для вывода

            internal int ClientNumber { get { return client.Number; } } // Номер клиента
            internal bool Awaiting { get; private set; } // True - клиент вызван и еще идёт
            internal bool Finished { get; private set; } // True - обслуживание клиента завершено, и он покидает окно

            // Конструктор
            internal Employee(RealClient _client, Point _destination, ListBox _box, Action _refreshQueue)
            {
                client = _client.Key;
                picture = _client.Value;
                destination = _destination;
                messageBox = _box;
                refreshQueue = _refreshQueue;

                if (rand == null) rand = new Random((int)(DateTime.Now.Ticks % int.MaxValue));

                Awaiting = true;
                
                timer = new Timer(MovePicture, null, Timeout.Infinite, Timeout.Infinite);
            }

            // Запуск движения автомобиля к базе
            internal void StartMoving()
            {
                timer.Change(0, 20);
            }
            // Движение автомобиля к базе
            private void MovePicture(object _)
            {
                var x = picture.Location.X;
                var y = picture.Location.Y;

                if (x < destination.X) x++;
                if (x > destination.X) x--;
                if (y < destination.Y) y++;
                if (y > destination.Y) y--;

                picture.BeginInvoke((Action)(() => picture.Location = new Point(x, y)));

                if (x == destination.X && y == destination.Y)
                {
                    timer.Change(Timeout.Infinite, Timeout.Infinite);
                    timer.Dispose();
                    timer = null;

                    StartWorking();
                }
            }
            // Запуск периодического вывода сообщений
            private void StartWorking()
            {
                Awaiting = false;
                picture.Invoke(refreshQueue);
                var period = rand.Next(500, 10000);
                var success = rand.Next() % 2 == 0;

                messages = success ? client.Operation.SuccessMessages : client.Operation.FailMessages;
                current = 0;
                
                timer = new Timer(Work, null, 0, period);
            }
            // Периодический вывод сообщений
            private void Work(object _)
            {
                if (current >= messages.Count)
                {
                    timer.Change(Timeout.Infinite, Timeout.Infinite);
                    timer.Dispose();
                    timer = null;

                    Finished = true;
                    timer = new Timer(Quit, null, 0, 10);
                }
                else
                {
                    messageBox.Invoke((Action)(() =>
                    {
                        messageBox.Items.Add(string.Format("{0}: {1}", client.Number, messages[current]));
                        messageBox.TopIndex = messageBox.Items.Count - 1;
                    }));

                    current++;
                }
            }
            // Автомобиль уезжает из депо
            private void Quit(object _)
            {
                Bitmap bitmap1 = client.AutoType == Auto.vehicle ? BankService.Properties.Resources.car : BankService.Properties.Resources.bus;
                int x = picture.Location.X, y = picture.Location.Y;
                bitmap1.RotateFlip(RotateFlipType.Rotate180FlipY);
                picture.Image = bitmap1;
                if (x < 350)
                {
                    x++;
                    picture.Invoke((Action)(() => picture.Location = new Point(x, y)));
                }
                else
                {
                    timer.Change(Timeout.Infinite, Timeout.Infinite);
                    timer.Dispose();

                    picture.Invoke((Action)(() => picture.Dispose()));
                }
            }
        }
    }
}