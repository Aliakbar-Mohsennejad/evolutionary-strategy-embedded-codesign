% main_script.m
% اسکریپت اصلی برای اجرای پروژه هم‌طراحی الگوریتم استراتژی‌های تکاملی (ES)
% روی مسئله Knapsack با انتخاب سخت‌افزار (SystemC) یا فقط نرم‌افزار (MATLAB)

clear; close all; clc; % پاکسازی محیط اجرا

%% === عنوان پروژه ===
fprintf('=== پروژه هم‌طراحی سخت‌افزار و نرم‌افزار ===\n');
fprintf('پیاده‌سازی الگوریتم استراتژی‌های تکاملی برای مسئله کوله‌پشتی\n');

%% --- تنظیمات اجرا ---
use_hardware = true;  % true = استفاده از SystemC | false = فقط MATLAB

%% --- حذف فایل‌های موقتی قبلی (برای جلوگیری از تداخل اجراهای قبلی) ---
delete_if_exists('matlab_to_systemc.dat');
delete_if_exists('systemc_to_matlab.dat');
delete_if_exists('params.dat');

%% --- اجرای الگوریتم ---
tic;  % شروع زمان‌سنجی
if use_hardware
    [best_solution, best_fitness, history] = evolutionary_strategy_knapsack();
else
    [best_solution, best_fitness, history] = evolutionary_strategy_knapsack_software();
end
time_elapsed = toc;  % زمان صرف‌شده اجرای کل الگوریتم

%% --- محاسبه خروجی‌ها و تحلیل جواب ---
items_price = [6, 5, 8, 9, 6, 7, 3, 6];   % ارزش آیتم‌ها
items_weight = [2, 3, 6, 7, 5, 9, 3, 4];  % وزن آیتم‌ها
max_weight = 15;  % محدودیت وزن کل

% محاسبه وزن و ارزش جواب نهایی بر اساس بهترین راه‌حل پیدا شده
total_weight = sum(best_solution .* items_weight);
total_value = sum(best_solution .* items_price);
selected_items = sum(best_solution > 0.5);  % تعداد آیتم‌هایی که احتمال انتخاب > 0.5 دارند

%% --- چاپ نتایج نهایی ---
fprintf('=== نتایج نهایی ===\n');
fprintf('بهترین ترکیب یافت شده (درصد انتخاب هر آیتم):\n');
disp(best_solution);

fprintf('شایستگی: %.2f | وزن کل: %.2f / %d | ارزش: %.2f\n', ...
    best_fitness, total_weight, max_weight, total_value);

fprintf('آیتم‌های انتخاب‌شده: %d از %d | استفاده از ظرفیت: %.2f%%\n', ...
    selected_items, length(best_solution), (total_weight / max_weight) * 100);

fprintf('زمان اجرا: %.2f ثانیه\n', time_elapsed);

%% --- حذف فایل‌های موقت در پایان اجرا ---
delete_if_exists('matlab_to_systemc.dat');
delete_if_exists('systemc_to_matlab.dat');
delete_if_exists('params.dat');

%% --- رسم نمودار همگرایی الگوریتم ---
valid_length = find(history.best_fitness == 0, 1) - 1;  % تعداد نسل‌های معتبر (قبل از صفرشدن احتمالی)
if isempty(valid_length)
    valid_length = length(history.best_fitness);
end

figure;
plot(1:valid_length, history.best_fitness(1:valid_length), 'b', 'LineWidth', 2);
hold on;
plot(1:valid_length, history.avg_fitness(1:valid_length), 'r--', 'LineWidth', 2);
xlabel('نسل'); ylabel('شایستگی');
title('همگرایی الگوریتم استراتژی تکاملی');
legend('بهترین شایستگی','میانگین شایستگی','Location','southeast');
grid on;

%% --- تابع جانبی برای حذف فایل در صورت وجود ---
function delete_if_exists(filename)
    if exist(filename, 'file')
        delete(filename);
    end
end
