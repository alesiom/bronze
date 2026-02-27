-- Migration: Seed athlete_social with handles from docs/archive/ATHLETE_SOCIAL_HANDLES.md
-- Run with: docker exec -i bronze-db psql -U postgres -d neve26 -f - < migrations/085_seed_athlete_handles.sql

INSERT INTO athlete_social (athlete_name, athlete_slug, country_code, sport, instagram_handle, twitter_handle, discovery_method)
VALUES
    -- Alpine Skiing - Men
    ('Marco Odermatt', 'marco-odermatt', 'SUI', 'Alpine Skiing', 'marco_odermatt', 'MarcoOdermatt', 'manual'),
    ('Aleksander Aamodt Kilde', 'aleksander-aamodt-kilde', 'NOR', 'Alpine Skiing', 'aleksander.kilde', 'AleksanderKilde', 'manual'),
    ('Henrik Kristoffersen', 'henrik-kristoffersen', 'NOR', 'Alpine Skiing', 'henrik_kristoffersen', NULL, 'manual'),
    ('Lucas Braathen', 'lucas-braathen', 'BRA', 'Alpine Skiing', 'lucasbraathen', NULL, 'manual'),
    ('Loic Meillard', 'loic-meillard', 'SUI', 'Alpine Skiing', 'loicmeillard', NULL, 'manual'),
    ('Vincent Kriechmayr', 'vincent-kriechmayr', 'AUT', 'Alpine Skiing', 'vincent_kriechmayr', NULL, 'manual'),
    ('Cyprien Sarrazin', 'cyprien-sarrazin', 'FRA', 'Alpine Skiing', 'cypriensarrazin', NULL, 'manual'),
    ('Dominik Paris', 'dominik-paris', 'ITA', 'Alpine Skiing', 'dominikparis', NULL, 'manual'),
    ('Manuel Feller', 'manuel-feller', 'AUT', 'Alpine Skiing', 'manuelfeller', NULL, 'manual'),
    ('Zan Kranjec', 'zan-kranjec', 'SLO', 'Alpine Skiing', 'zan_kransen', NULL, 'manual'),

    -- Alpine Skiing - Women
    ('Mikaela Shiffrin', 'mikaela-shiffrin', 'USA', 'Alpine Skiing', 'mikaelashiffrin', 'MikaelaShiffrin', 'manual'),
    ('Lara Gut-Behrami', 'lara-gut-behrami', 'SUI', 'Alpine Skiing', 'laborosov', NULL, 'manual'),
    ('Federica Brignone', 'federica-brignone', 'ITA', 'Alpine Skiing', 'federicabrignone', NULL, 'manual'),
    ('Sofia Goggia', 'sofia-goggia', 'ITA', 'Alpine Skiing', 'sofia_goggia', NULL, 'manual'),
    ('Petra Vlhova', 'petra-vlhova', 'SVK', 'Alpine Skiing', 'petravlhova', NULL, 'manual'),
    ('Cornelia Huetter', 'cornelia-huetter', 'AUT', 'Alpine Skiing', 'cornihuetter', NULL, 'manual'),
    ('Ilka Stuhec', 'ilka-stuhec', 'SLO', 'Alpine Skiing', 'ilkastuhec', NULL, 'manual'),
    ('Wendy Holdener', 'wendy-holdener', 'SUI', 'Alpine Skiing', 'wendyholdener', NULL, 'manual'),
    ('Corinne Suter', 'corinne-suter', 'SUI', 'Alpine Skiing', 'corinnesuter', NULL, 'manual'),

    -- Biathlon - Men
    ('Johannes Thingnes Boe', 'johannes-thingnes-boe', 'NOR', 'Biathlon', 'johannesthingnesboe', NULL, 'manual'),
    ('Tarjei Boe', 'tarjei-boe', 'NOR', 'Biathlon', 'tarjeiboe', NULL, 'manual'),
    ('Quentin Fillon Maillet', 'quentin-fillon-maillet', 'FRA', 'Biathlon', 'quentinfillonmaillet', NULL, 'manual'),
    ('Emilien Jacquelin', 'emilien-jacquelin', 'FRA', 'Biathlon', 'emilienjacquelin', NULL, 'manual'),
    ('Sebastian Samuelsson', 'sebastian-samuelsson', 'SWE', 'Biathlon', 'sebastiansamuelsson', NULL, 'manual'),
    ('Sturla Holm Laegreid', 'sturla-holm-laegreid', 'NOR', 'Biathlon', 'sturlaholmlaegreid', NULL, 'manual'),
    ('Benedikt Doll', 'benedikt-doll', 'GER', 'Biathlon', 'benediktdoll', NULL, 'manual'),

    -- Biathlon - Women
    ('Lisa Vittozzi', 'lisa-vittozzi', 'ITA', 'Biathlon', 'lisa_vittozzi', NULL, 'manual'),
    ('Lou Jeanmonnot', 'lou-jeanmonnot', 'FRA', 'Biathlon', 'loujeanmonnot', NULL, 'manual'),
    ('Justine Braisaz-Bouchet', 'justine-braisaz-bouchet', 'FRA', 'Biathlon', 'justinebraisaz', NULL, 'manual'),
    ('Elvira Oeberg', 'elvira-oeberg', 'SWE', 'Biathlon', 'elviraoeberg', NULL, 'manual'),
    ('Hanna Oeberg', 'hanna-oeberg', 'SWE', 'Biathlon', 'hannaoeberg', NULL, 'manual'),
    ('Franziska Preuss', 'franziska-preuss', 'GER', 'Biathlon', 'franziska.preuss', NULL, 'manual'),
    ('Marte Olsbu Roeiseland', 'marte-olsbu-roeiseland', 'NOR', 'Biathlon', 'marteolsburoeiseland', NULL, 'manual'),

    -- Cross-Country Skiing
    ('Johannes Hoesflot Klaebo', 'johannes-hoesflot-klaebo', 'NOR', 'Cross-Country Skiing', 'johanneshk', NULL, 'manual'),
    ('Jessie Diggins', 'jessie-diggins', 'USA', 'Cross-Country Skiing', 'jessiediggins', 'JessieDiggins', 'manual'),
    ('Therese Johaug', 'therese-johaug', 'NOR', 'Cross-Country Skiing', 'theresejohaug', NULL, 'manual'),
    ('Frida Karlsson', 'frida-karlsson', 'SWE', 'Cross-Country Skiing', 'fridakarlsson', NULL, 'manual'),

    -- Ski Jumping
    ('Ryoyu Kobayashi', 'ryoyu-kobayashi', 'JPN', 'Ski Jumping', 'ryoyu_kobayashi', NULL, 'manual'),
    ('Anze Lanisek', 'anze-lanisek', 'SLO', 'Ski Jumping', 'anzelanisek', NULL, 'manual'),
    ('Stefan Kraft', 'stefan-kraft', 'AUT', 'Ski Jumping', 'stefankraft', NULL, 'manual'),
    ('Halvor Egner Granerud', 'halvor-egner-granerud', 'NOR', 'Ski Jumping', 'halvoregnergaborosov', NULL, 'manual')

ON CONFLICT (athlete_slug) DO NOTHING;
