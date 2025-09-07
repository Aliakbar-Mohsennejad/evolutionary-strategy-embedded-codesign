function offspring = hardware_accelerated_operations(parents, recombination_rate, mutation_rate)
    % این تابع با بخش سخت‌افزاری ارتباط برقرار می‌کند
    % در حالت شبیه‌سازی، این عملیات در خود MATLAB انجام می‌شود
    % ورودی:
    %   parents: ماتریس والدین
    %   recombination_rate: نرخ بازترکیب
    %   mutation_rate: نرخ جهش
    % خروجی:
    %   offspring: فرزندان تولید شده
    
    num_parents = size(parents, 1);
    offspring = zeros(num_parents, size(parents, 2));  % پیش‌تخصیص حافظه
    
    % شبیه‌سازی ارتباط با سخت‌افزار از طریق فایل
    % 1. ذخیره والدین در فایل
    dlmwrite('matlab_to_systemc.dat', parents, 'delimiter', '\t');
    dlmwrite('params.dat', [recombination_rate, mutation_rate], 'delimiter', '\t');
    
    % 2. انتظار برای پردازش سخت‌افزاری
    while ~exist('systemc_to_matlab.dat', 'file')
        pause(0.1);  % تأخیر کوتاه برای کاهش بار CPU
    end
    
    % 3. خواندن نتایج
    offspring = dlmread('systemc_to_matlab.dat');
    
    % 4. پاکسازی فایل‌های موقت
    delete('systemc_to_matlab.dat');
end