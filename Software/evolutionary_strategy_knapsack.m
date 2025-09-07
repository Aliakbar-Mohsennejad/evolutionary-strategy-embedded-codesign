function [best_solution, best_fitness, history] = evolutionary_strategy_knapsack()
    % الگوریتم استراتژی تکاملی برای مسئله Knapsack با اجرای سخت‌افزاری (SystemC)

    %% --- تنظیم پارامترهای الگوریتم ---
    population_size = 50;        % اندازه جمعیت (μ)
    offspring_size = 30;         % تعداد فرزندان تولید شده در هر نسل (λ)
    mutation_rate = 0.1;         % نرخ جهش
    recombination_rate = 0.7;    % نرخ بازترکیب
    max_generations = 100;       % حداکثر تعداد نسل‌ها
    max_weight = 15;             % محدودیت وزن کل در کوله‌پشتی

    % مشخصات آیتم‌های مسئله
    items_price = [6, 5, 8, 9, 6, 7, 3, 6];   % ارزش‌ها
    items_weight = [2, 3, 6, 7, 5, 9, 3, 4];  % وزن‌ها

    %% --- تولید جمعیت اولیه به‌صورت تصادفی ---
    population = rand(population_size, length(items_price));

    %% --- آماده‌سازی برای ذخیره‌سازی تاریخچه شایستگی ---
    history.best_fitness = zeros(1, max_generations);
    history.avg_fitness = zeros(1, max_generations);

    %% --- شروع حلقه تکاملی نسل‌ها ---
    for gen = 1:max_generations
        % ارزیابی شایستگی جمعیت فعلی
        fitness = evaluate_fitness(population, items_price, items_weight, max_weight);

        % ذخیره بهترین و میانگین شایستگی برای این نسل
        history.best_fitness(gen) = max(fitness);
        history.avg_fitness(gen) = mean(fitness);

        % نمایش وضعیت فعلی
        fprintf('نسل %d: بهترین شایستگی = %.3f\n', gen, history.best_fitness(gen));

        %% --- بررسی شرط توقف (همگرایی): اگر ۵ نسل اخیر شایستگی ثابتی داشته باشند (تا ۳ رقم اعشار) ---
        if gen > 5 && (gen - 4) > 5
            equal_rounded = true;
            target_value = round(history.best_fitness(gen), 3);
            for k = 0:4
                if round(history.best_fitness(gen - k), 3) ~= target_value
                    equal_rounded = false;
                    break;
                end
            end
            if equal_rounded
                fprintf('شرط توقف: از نسل %d تا %d مقدار شایستگی (تا ۳ رقم اعشار) برابر بود → توقف در نسل %d\n', ...
                        gen-4, gen, gen);
                break;
            end
        end

        %% --- انتخاب والدین با استفاده از روش تورنومنت ---
        parents = select_parents(population, fitness, offspring_size);

        %% --- ارسال والدین به SystemC و دریافت فرزندان جدید ---
        offspring = hardware_accelerated_operations(parents, recombination_rate, mutation_rate);

        %% --- ارزیابی شایستگی فرزندان ---
        offspring_fitness = evaluate_fitness(offspring, items_price, items_weight, max_weight);

        %% --- انتخاب جمعیت جدید از بین جمعیت قبلی + فرزندان ---
        [population, fitness] = select_new_population([population; offspring], ...
                                                      [fitness; offspring_fitness], ...
                                                      population_size);
    end

    %% --- استخراج بهترین جواب نهایی ---
    [best_fitness, idx] = max(fitness);
    best_solution = population(idx, :);
end
