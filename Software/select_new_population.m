function [new_population, new_fitness] = select_new_population(combined_pop, combined_fitness, pop_size)
    [~, idx] = sort(combined_fitness, 'descend');
    new_population = combined_pop(idx(1:pop_size), :);
    new_fitness = combined_fitness(idx(1:pop_size));
end