#ifndef REPAIR_MODULE_H
#define REPAIR_MODULE_H

#include <systemc.h>
#include <vector>

SC_MODULE(RepairModule) {
    sc_in<bool> clk;
    
    // پارامترهای مسئله
    float max_weight;
    std::vector<float> items_weight;
    
    SC_CTOR(RepairModule) {
        // مقادیر پیش‌فرض
        max_weight = 15.0f;
        items_weight = {2, 3, 6, 7, 5, 9, 3, 4};
    }
    
    void set_parameters(float max_w, const std::vector<float>& weights) {
        max_weight = max_w;
        items_weight = weights;
    }
};

#endif // REPAIR_MODULE_H