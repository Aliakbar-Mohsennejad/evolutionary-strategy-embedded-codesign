#ifndef CHROMOSOME_H
#define CHROMOSOME_H

#include <systemc>
using namespace sc_core;
using namespace sc_dt;

SC_MODULE(Chromosome) {
    sc_in<bool> clk;
    sc_in<bool> enable;
    sc_out<float> total_profit;
    sc_out<float> total_weight;

    void process() {
        while (true) {
            wait();
            if (enable.read()) {
                float profit = (rand() % 10000) / 100.0f;
                float weight = (rand() % 2500) / 100.0f;
                total_profit.write(profit);
                total_weight.write(weight);
            }
        }
    }

    SC_CTOR(Chromosome) {
        SC_THREAD(process);
        sensitive << clk.pos();
    }
};

#endif // CHROMOSOME_H

