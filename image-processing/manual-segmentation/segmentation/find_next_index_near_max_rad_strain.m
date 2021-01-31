function index_AntTotal = find_next_index_near_max_rad_strain(radInfSeptTotal)

index_AntTotal = find(radInfSeptTotal == max(radInfSeptTotal));
if index_AntTotal ~= length(radInfSeptTotal)
        index_AntTotal = index_AntTotal + 1;
end