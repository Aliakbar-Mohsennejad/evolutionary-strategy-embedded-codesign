function parents = select_parents(population, fitness, num_parents)
    % این تابع والدین را برای تولید نسل بعد انتخاب می‌کند
    % روش انتخاب: تورنمنت (Tournament Selection)
    % ورودی:
    %   population: جمعیت فعلی
    %   fitness: مقادیر شایستگی
    %   num_parents: تعداد والدین مورد نیاز
    % خروجی:
    %   parents: والدین انتخاب شده
    
    parents = zeros(num_parents, size(population, 2));  % پیش‌تخصیص حافظه
    
    for i = 1:num_parents
        % انتخاب 4 عضو تصادفی برای رقابت تورنمنت
        candidates = randperm(size(population, 1), 4);
        
        % انتخاب برنده (بالاترین شایستگی)
        [~, idx] = max(fitness(candidates));
        
        % ذخیره والد انتخاب شده
        parents(i, :) = population(candidates(idx), :);
    end
end