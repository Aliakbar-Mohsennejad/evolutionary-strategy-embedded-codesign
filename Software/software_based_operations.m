function offspring = software_based_operations(parents, recombination_rate, mutation_rate)
    num_parents = size(parents, 1);
    chromosome_length = size(parents, 2);
    offspring = zeros(num_parents, chromosome_length);

    for i = 1:2:num_parents
        p1 = parents(i, :);
        p2 = parents(i+1, :);

        % بازترکیب یک نقطه‌ای
        if rand < recombination_rate
            point = randi([1, chromosome_length-1]);
            c1 = [p1(1:point), p2(point+1:end)];
            c2 = [p2(1:point), p1(point+1:end)];
        else
            c1 = p1;
            c2 = p2;
        end

        % جهش گاوسی
        c1 = mutate(c1, mutation_rate);
        c2 = mutate(c2, mutation_rate);

        offspring(i, :) = c1;
        offspring(i+1, :) = c2;
    end
end

function mutated = mutate(chromosome, mutation_rate)
    mutated = chromosome;
    for i = 1:length(chromosome)
        if rand < mutation_rate
            mutated(i) = min(1, max(0, chromosome(i) + randn * 0.1));
        end
    end
end
