function plot_root_system_RSMAFI(units, tDay, Df_t, theta1, refLimit, depthMin, depthMax)
%PLOT_ROOT_SYSTEM_RSMAFI Plot a 3-D root system in a single axes.

    cmap = jet(256);
    hold on;

    for u = 1:numel(units)
        seg = units(u);
        zMid = mean([seg.start(3) seg.finish(3)]);
        idx  = round( (zMid - depthMin)/(depthMax - depthMin) * 255 ) + 1;
        idx  = max(1,min(256,idx));
        plot3([seg.start(1) seg.finish(1)], ...
              [seg.start(2) seg.finish(2)], ...
              [seg.start(3) seg.finish(3)], ...
              'Color',cmap(idx,:),'LineWidth',1.0);
    end

    axis equal;
    xlim([-refLimit refLimit]);
    ylim([-refLimit refLimit]);
    zlim([depthMin depthMax]);

    xticks(-60:30:60);
    yticks(-60:30:60);
    zticks(-120:30:0);

    ax = gca;
    ax.LineWidth = 2;
    ax.FontWeight = 'bold';

    xlabel('x (mm)');
    ylabel('y (mm)');
    zlabel('Depth (mm)');

    title(sprintf('Day = %d   D_f = %.3f   theta = %.1f¡ã', ...
          tDay, Df_t, theta1));

    view([-50 20]);
    colormap(jet);
    grid off;
    hold off;
end
