function fitness = evaluate_fitness(population, prices, weights, max_weight)
    % این تابع شایستگی هر فرد در جمعیت را محاسبه می‌کند
    fitness = zeros(size(population, 1), 1);  % پیش‌تخصیص

    for i = 1:size(population, 1)
        total_weight = sum(population(i, :) .* weights);
        total_value = sum(population(i, :) .* prices);

        if total_weight > max_weight
            % جریمه سنگین‌تر برای وزن‌های غیرمجاز
           if total_weight > max_weight
                 fitness(i) = 0;  % رد کامل جواب‌های سنگین‌تر از مجاز
           else
                  fitness(i) = total_value;
            end

        else
            fitness(i) = total_value;
        end
    end
end
