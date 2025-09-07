function [best_solution, best_fitness, history] = evolutionary_strategy_knapsack_software()
    % نسخه نرم‌افزاری کامل بدون SystemC

    % پارامترها
    population_size = 50;
    offspring_size = 30;
    mutation_rate = 0.1;
    recombination_rate = 0.7;
    max_generations = 100;
    max_weight = 15;

    % داده‌های آیتم‌ها
    items_price = [6, 5, 8, 9, 6, 7, 3, 6];
    items_weight = [2, 3, 6, 7, 5, 9, 3, 4];

    % جمعیت اولیه
    population = rand(population_size, length(items_price));

    % تاریخچه شایستگی‌ها
    history.best_fitness = zeros(1, max_generations);
    history.avg_fitness = zeros(1, max_generations);
    history.stagnation = 0;

    % حلقه تکاملی
    for gen = 1:max_generations
        fitness = evaluate_fitness(population, items_price, items_weight, max_weight);

        history.best_fitness(gen) = max(fitness);
        history.avg_fitness(gen) = mean(fitness);

        fprintf('نسل %d: بهترین شایستگی = %.2f\n', gen, history.best_fitness(gen));

        if gen > 5 && history.best_fitness(gen) == history.best_fitness(gen-1)
            history.stagnation = history.stagnation + 1;
            if history.stagnation >= 5
                fprintf('شرط توقف در نسل %d (عدم بهبود در 5 نسل متوالی)\n', gen);
                break;
            end
        else
            history.stagnation = 0;
        end

        parents = select_parents(population, fitness, offspring_size);
        offspring = software_based_operations(parents, recombination_rate, mutation_rate);
        offspring_fitness = evaluate_fitness(offspring, items_price, items_weight, max_weight);
        [population, fitness] = select_new_population([population; offspring], [fitness; offspring_fitness], population_size);
    end

    [best_fitness, idx] = max(fitness);
    best_solution = population(idx, :);
end