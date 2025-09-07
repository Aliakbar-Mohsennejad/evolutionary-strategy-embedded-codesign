#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <systemc>
using namespace sc_core;
using namespace sc_dt;

SC_MODULE(Controller) {
    sc_in<bool> clk;
    sc_in<bool> start;
    sc_out<bool> enable_chromosome;
    sc_out<bool> done;

    int generation;
    const int max_generations = 10;

    void control_process() {
        generation = 0;
        done.write(false);
        enable_chromosome.write(false);
        wait();

        while (true) {
            if (start.read()) {
                enable_chromosome.write(true);
                wait(2); // فرضی: 2 سیکل فرصت محاسبه کروموزوم
                generation++;
                enable_chromosome.write(false);

                if (generation >= max_generations) {
                    done.write(true);
                }
            }
            wait();
        }
    }

    SC_CTOR(Controller) {
        SC_THREAD(control_process);
        sensitive << clk.pos();
    }
};

#endif // CONTROLLER_H

