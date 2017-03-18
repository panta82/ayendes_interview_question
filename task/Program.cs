using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApplication1
{
    public class Record
    {
        public DateTime Start { get; set; }
        public DateTime End { get; set; }
        public long Id { get; set; }
        public TimeSpan Duration => End - Start;
    }

    class Program
    {
        static void Main(string[] args)
        {
            AppDomain.MonitoringIsEnabled = true;
            var sp = Stopwatch.StartNew();

            const string path = @"data.txt";
            var summary = from line in File.ReadAllLines(path)
                let parts = line.Split(' ')
                let record = new Record
                {
                    Start = DateTime.Parse(parts[0]),
                    End = DateTime.Parse(parts[1]),
                    Id = long.Parse(parts[2])
                }
                group record by record.Id
                into g
                select new
                {
                    Id = g.Key,
                    Duration = TimeSpan.FromTicks(g.Sum(r => r.Duration.Ticks))
                };

            using (var output = File.CreateText("summary.txt"))
            {
                foreach (var entry in summary)
                {
                    output.WriteLine($"{entry.Id:D10} {entry.Duration:c}");
                }
            }

            Console.WriteLine($"Took: {sp.ElapsedMilliseconds:#,#} ms and allocated {AppDomain.CurrentDomain.MonitoringTotalAllocatedMemorySize/1024:#,#} kb with peak working set of {Process.GetCurrentProcess().PeakWorkingSet64/1024:#,#} kb");

        }
    }
}
