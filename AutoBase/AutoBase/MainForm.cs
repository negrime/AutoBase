using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;

namespace AutoBase
{
    public partial class MainForm : Form
    {
        private Controller control;

        public MainForm()
        {
            InitializeComponent();

            control = new Controller(panel, queueBox, actionsBox);
        }

        private void startService_Click(object sender, EventArgs e)
        {
            startService.Enabled = false;

            control.Start();

            stopService.Enabled = true;
        }

        private void stopService_Click(object sender, EventArgs e)
        {
            stopService.Enabled = false;

            control.Stop();

            startService.Enabled = true;
        }

        private void addButton_Click(object sender, EventArgs e)
        {
            control.Add();
        }

        private void MainForm_Load(object sender, EventArgs e)
        {

        }
    }
}