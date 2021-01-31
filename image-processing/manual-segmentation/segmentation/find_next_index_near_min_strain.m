function index_AntTotal = find_next_index_near_min_strain(cirInfSeptTotal)

index_AntTotal = find(cirInfSeptTotal == min(cirInfSeptTotal));
if index_AntTotal ~= length(cirInfSeptTotal)
        index_AntTotal = index_AntTotal + 1;
end