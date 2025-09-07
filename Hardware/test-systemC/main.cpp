#include <systemc.h>
#include "evolutionary_strategy.h"
#include <fstream>
#include <vector>
#include <chrono>
#include <thread>
using namespace std;

int sc_main(int argc, char* argv[]) {
    EvolutionaryStrategy es("ES_Module");

    // سیگنال‌ها
    sc_clock clk("clk", 10, SC_NS);
    sc_signal<bool> start, done;
    sc_signal<sc_uint<32>> data_in, data_out;
    sc_signal<bool> data_valid, data_ready;

    // اتصال سیگنال‌ها
    es.clk(clk);
    es.start(start);
    es.done(done);
    es.data_in(data_in);
    es.data_out(data_out);
    es.data_valid(data_valid);
    es.data_ready(data_ready);

    cout << "SystemC module started." << endl;

    // حلقه ارتباط با MATLAB
    while (true) {
        ifstream infile("matlab_to_systemc.dat");
        if (infile.good()) {
            cout << "Receiving data from MATLAB..." << endl;

            ifstream paramfile("params.dat");
            float recombination_rate, mutation_rate;
            paramfile >> recombination_rate >> mutation_rate;
            paramfile.close();

            vector<vector<float>> parents;
            float value;
            while (infile >> value) {
                vector<float> parent;
                parent.push_back(value);
                for (int i = 1; i < es.chromosome_length; ++i) {
                    infile >> value;
                    parent.push_back(value);
                }
                parents.push_back(parent);
            }
            infile.close();
            remove("matlab_to_systemc.dat");
            remove("params.dat");

            vector<vector<float>> offspring = es.process_parents(parents, recombination_rate, mutation_rate);

            ofstream outfile("systemc_to_matlab.dat");
            for (const auto& child : offspring) {
                for (float gene : child) {
                    outfile << gene << "\t";
                }
                outfile << endl;
            }
            outfile.close();

            cout << "Processing complete. Output written to file." << endl;
        }

        this_thread::sleep_for(chrono::milliseconds(100));
    }

    return 0;
}
