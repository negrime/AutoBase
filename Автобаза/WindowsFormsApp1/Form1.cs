using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AutoBase
{
    public partial class Form1 : Form
    {
        private Controller control;
        private int tick, time;
        Random rnd = new Random();

        public Form1()
        {
            InitializeComponent();
            control = Controller.getInstance(panel, actionsBox);
            tick = 0;
            time = 0;

            timer.Start();
        }

        private void start_Click(object sender, EventArgs e)
        {
            
            stop.Enabled = false;

            control.Start();

            stop.Enabled = true;
        }

        private void stop_Click(object sender, EventArgs e)
        {
            stop.Enabled = false;

            control.Stop();

            start.Enabled = true;
        }


        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        {
            control.Exit();
        }

        private void timer_Tick(object sender, EventArgs e)
        {
            tick++;
            if (tick > time)
            {
                control.Add();
                tick = 0;
                time = rnd.Next(2, 5);
            }

        }
    }
}
