% To find the displacement along a uniaxial loaded bar.
clc;
clear;
close all;

d = input("Give the diameter of Specimen [d1 d2 d3] in mtr:");
E = [6 6 6]*1e9;
A = (pi* d.^2)/4;
L = [0.08 0.08 0.08];
n_elm = 3;
n_nds =n_elm + 1;

K = zeros(n_nds, n_nds);
for e = 1: n_elm
    ke = (A(e)*E(e)/L(e)) *  [1 -1;
                             -1  1];
    K(e:e+1, e:e+1) = K(e:e+1, e:e+1) + ke;
end

disp('Global Stiffness Matrix:');
disp(K)


F = zeros(n_nds,1);
F(2) = 50;
F(3) = 100;

fix_node = 1;
free_nodes = 2:n_nds;

K_reduced = K(free_nodes, free_nodes);
f_reduced = F(free_nodes);

U=zeros(n_nds,1);
U(free_nodes) = K_reduced\f_reduced;
u_reduced = U(free_nodes);

disp('Nodal Displacement (m):');
disp(u_reduced)

stress = zeros(n_elm,1);
for e = 1: n_elm
    strain = (U(e+1)- U(e)) / L(e);
    stress(e) = E(e) * strain;
end

disp('Element Stresses (Pa):');
disp(stress)

figure;
grid on;
node = 1: n_nds;
plot(node, U);
xlabel('Node number');
ylabel('Displacement (m)');
title('Displacement vs Node');


figure;
hold on;
grid on;
for e = 1: n_elm
    plot([e e+1],[stress(e) stress(e)]);
end
xlabel('Node number');
ylabel('Stress (Pa)');
title('Stress vs Node');
