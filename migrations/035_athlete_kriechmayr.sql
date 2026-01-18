-- Migration: 035_athlete_kriechmayr.sql
-- Athlete Profile: Vincent Kriechmayr (Austrian Alpine Skiing - Speed)
-- Created: 2025-01-11

INSERT INTO articles (
    slug,
    title,
    excerpt,
    content,
    category,
    sport_code,
    meta_description,
    status,
    published_at,
    source_type
) VALUES (
    'vincent-kriechmayr-alpine-skiing-profile',
    '{
        "en": "Vincent Kriechmayr: Austria''s Speed Skiing Champion",
        "de": "Vincent Kriechmayr: Oesterreichs Geschwindigkeitsskikoenig",
        "fr": "Vincent Kriechmayr: Le champion autrichien de vitesse",
        "it": "Vincent Kriechmayr: Il campione austriaco della velocita",
        "es": "Vincent Kriechmayr: El campeon austriaco de velocidad",
        "pt": "Vincent Kriechmayr: O campeao austriaco de velocidade",
        "nl": "Vincent Kriechmayr: De Oostenrijkse snelheidskampioen",
        "ar": "فينسنت كريشماير: بطل السرعة النمساوي",
        "ja": "ヴィンセント・クリーヒマイヤー：オーストリアのスピードスキーチャンピオン",
        "zh": "Vincent Kriechmayr: Aodili sudu huaxue guanjun",
        "ko": "빈센트 크리히마이어: 오스트리아의 스피드 스키 챔피언"
    }'::jsonb,
    '{
        "en": "The Austrian speed specialist who has claimed World Championship gold medals in both downhill and super-G while racing fearlessly on the most demanding courses.",
        "de": "Der oesterreichische Geschwindigkeitsspezialist, der WM-Goldmedaillen in Abfahrt und Super-G gewonnen hat.",
        "fr": "Le specialiste autrichien de la vitesse qui a remporte des medailles d''or mondiales en descente et super-G.",
        "it": "Lo specialista austriaco della velocita che ha conquistato ori mondiali in discesa e super-G.",
        "es": "El especialista austriaco de velocidad que ha ganado oros mundiales en descenso y super-G.",
        "pt": "O especialista austriaco de velocidade que conquistou ouros mundiais em descida e super-G.",
        "nl": "De Oostenrijkse snelheidsspecialist die WK-goud heeft gewonnen in afdaling en super-G.",
        "ar": "متخصص السرعة النمساوي الذي حصل على ذهبيات عالمية في الانحدار والسوبر جي",
        "ja": "ダウンヒルとスーパーGで世界選手権金メダルを獲得したオーストリアのスピードスペシャリスト",
        "zh": "Zai suxiang he chaojidashuixuan zhong huode shijie jinbiaosai jinpai de Aodili sudu zhuanjia",
        "ko": "다운힐과 슈퍼-G에서 세계선수권 금메달을 획득한 오스트리아 스피드 스페셜리스트"
    }'::jsonb,
    '{
        "en": "<p>Vincent Kriechmayr represents the best of Austrian <a href=\"/alpine-skiing-guide/\">alpine skiing</a> tradition. The speed specialist has won World Championship gold medals in both downhill and super-G, establishing himself as one of the most complete speed skiers of his generation.</p><h2>Double World Champion</h2><p>At the 2021 World Championships in Cortina, Kriechmayr achieved something special. He won gold medals in both speed disciplines, the downhill and super-G. This double victory demonstrated his exceptional ability across both events and placed him among the legends of Austrian skiing.</p><h2>Fearless Approach</h2><p>Speed skiing demands courage, and Kriechmayr delivers. He attacks the most difficult sections of courses where others hesitate. This fearless approach allows him to gain time in places that separate good skiers from champions. On courses like Kitzbuehel''s Streif, this bravery is essential for success.</p><h2>Austrian Skiing Heritage</h2><p>Austria has produced many of skiing''s greatest champions, and Kriechmayr continues this tradition. He carries the expectations of a nation passionate about skiing, performing on legendary home courses where fans fill every vantage point. This pressure has not diminished his performances.</p><h2>Technical Speed</h2><p>Unlike pure power skiers, Kriechmayr combines speed with technical precision. His line choice through difficult terrain and his ability to carry speed through turns set him apart. The super-G especially rewards this combination, requiring both racing instinct and technical skill.</p><h2>Consistent Competitor</h2><p>Beyond championship medals, Kriechmayr has accumulated numerous World Cup podiums and victories. His consistency season after season keeps him among the top-ranked speed skiers in the world. He rarely has poor results, delivering solid performances even when conditions are challenging.</p><h2>Competition at the Top</h2><p>Kriechmayr competes against speed skiing''s best, including <a href=\"/aleksander-aamodt-kilde-alpine-skiing-profile/\">Aleksander Aamodt Kilde</a> and other elite racers. These battles at the top create compelling competitions where fractions of seconds decide victories.</p><h2>Future Goals</h2><p>With World Championship gold already secured, Kriechmayr continues pursuing World Cup titles and further championship success. His combination of courage and skill makes him a favorite whenever speed events are contested at the sport''s highest level.</p>",
        "de": "<p>Vincent Kriechmayr repraesentiert das Beste der oesterreichischen <a href=\"/alpine-skiing-guide/\">alpinen Ski</a>-Tradition. Der Geschwindigkeitsspezialist hat WM-Goldmedaillen in Abfahrt und Super-G gewonnen.</p><h2>Doppelter Weltmeister</h2><p>Bei der WM 2021 in Cortina erreichte Kriechmayr etwas Besonderes. Er gewann Goldmedaillen in beiden Speed-Disziplinen.</p><h2>Furchtloser Ansatz</h2><p>Geschwindigkeitsskifahren erfordert Mut, und Kriechmayr liefert.</p><h2>Oesterreichisches Skierbe</h2><p>Oesterreich hat viele der groessten Ski-Champions hervorgebracht, und Kriechmayr setzt diese Tradition fort.</p><h2>Technische Geschwindigkeit</h2><p>Anders als reine Kraft-Skifahrer kombiniert Kriechmayr Geschwindigkeit mit technischer Praezision.</p><h2>Konstanter Konkurrent</h2><p>Ueber Meisterschaftsmedaillen hinaus hat Kriechmayr zahlreiche Weltcup-Podien und Siege gesammelt.</p><h2>Konkurrenz an der Spitze</h2><p>Kriechmayr tritt gegen die Besten im Speed-Skifahren an, darunter <a href=\"/aleksander-aamodt-kilde-alpine-skiing-profile/\">Aleksander Aamodt Kilde</a>.</p><h2>Zukuenftige Ziele</h2><p>Mit bereits gesichertem WM-Gold verfolgt Kriechmayr weiter Weltcup-Titel und weitere Meisterschaftserfolge.</p>",
        "fr": "<p>Vincent Kriechmayr represente le meilleur de la tradition du <a href=\"/alpine-skiing-guide/\">ski alpin</a> autrichien. Le specialiste de la vitesse a remporte des medailles d''or mondiales en descente et super-G.</p><h2>Double champion du monde</h2><p>Aux Championnats du monde 2021 a Cortina, Kriechmayr a realise quelque chose de special. Il a remporte l''or dans les deux disciplines de vitesse.</p><h2>Approche intrepide</h2><p>Le ski de vitesse exige du courage, et Kriechmayr le delivre.</p><h2>Heritage du ski autrichien</h2><p>L''Autriche a produit beaucoup des plus grands champions du ski, et Kriechmayr poursuit cette tradition.</p><h2>Vitesse technique</h2><p>Contrairement aux skieurs de pure puissance, Kriechmayr combine vitesse et precision technique.</p><h2>Competiteur constant</h2><p>Au-dela des medailles de championnat, Kriechmayr a accumule de nombreux podiums et victoires en Coupe du monde.</p><h2>Competition au sommet</h2><p>Kriechmayr affronte les meilleurs du ski de vitesse, dont <a href=\"/aleksander-aamodt-kilde-alpine-skiing-profile/\">Aleksander Aamodt Kilde</a>.</p><h2>Objectifs futurs</h2><p>Avec l''or mondial deja assure, Kriechmayr continue de poursuivre les titres en Coupe du monde.</p>",
        "it": "<p>Vincent Kriechmayr rappresenta il meglio della tradizione dello <a href=\"/alpine-skiing-guide/\">sci alpino</a> austriaco. Lo specialista della velocita ha vinto ori mondiali in discesa e super-G.</p><h2>Doppio campione del mondo</h2><p>Ai Mondiali 2021 a Cortina, Kriechmayr ha realizzato qualcosa di speciale. Ha vinto l''oro in entrambe le discipline veloci.</p><h2>Approccio senza paura</h2><p>Lo sci di velocita richiede coraggio, e Kriechmayr lo dimostra.</p><h2>Eredita dello sci austriaco</h2><p>L''Austria ha prodotto molti dei piu grandi campioni dello sci, e Kriechmayr continua questa tradizione.</p><h2>Velocita tecnica</h2><p>A differenza dei puri sciatori di potenza, Kriechmayr combina velocita con precisione tecnica.</p><h2>Competitore costante</h2><p>Oltre alle medaglie di campionato, Kriechmayr ha accumulato numerosi podi e vittorie in Coppa del Mondo.</p><h2>Competizione al vertice</h2><p>Kriechmayr compete contro i migliori dello sci veloce, tra cui <a href=\"/aleksander-aamodt-kilde-alpine-skiing-profile/\">Aleksander Aamodt Kilde</a>.</p><h2>Obiettivi futuri</h2><p>Con l''oro mondiale gia assicurato, Kriechmayr continua a inseguire titoli in Coppa del Mondo.</p>",
        "es": "<p>Vincent Kriechmayr representa lo mejor de la tradicion del <a href=\"/alpine-skiing-guide/\">esqui alpino</a> austriaco. El especialista de velocidad ha ganado oros mundiales en descenso y super-G.</p><h2>Doble campeon mundial</h2><p>En los Campeonatos Mundiales 2021 en Cortina, Kriechmayr logro algo especial. Gano oro en ambas disciplinas de velocidad.</p><h2>Enfoque intrépido</h2><p>El esqui de velocidad exige coraje, y Kriechmayr lo entrega.</p><h2>Herencia del esqui austriaco</h2><p>Austria ha producido muchos de los mas grandes campeones del esqui, y Kriechmayr continua esta tradicion.</p><h2>Velocidad tecnica</h2><p>A diferencia de los esquiadores de pura potencia, Kriechmayr combina velocidad con precision tecnica.</p><h2>Competidor constante</h2><p>Mas alla de las medallas de campeonato, Kriechmayr ha acumulado numerosos podios y victorias en Copa del Mundo.</p><h2>Competencia en la cima</h2><p>Kriechmayr compite contra los mejores del esqui de velocidad, incluyendo <a href=\"/aleksander-aamodt-kilde-alpine-skiing-profile/\">Aleksander Aamodt Kilde</a>.</p><h2>Metas futuras</h2><p>Con el oro mundial ya asegurado, Kriechmayr continua persiguiendo titulos de Copa del Mundo.</p>",
        "pt": "<p>Vincent Kriechmayr representa o melhor da tradicao do <a href=\"/alpine-skiing-guide/\">esqui alpino</a> austriaco. O especialista de velocidade ganhou ouros mundiais em descida e super-G.</p><h2>Duplo campeao mundial</h2><p>Nos Campeonatos Mundiais 2021 em Cortina, Kriechmayr alcancou algo especial. Ganhou ouro em ambas as disciplinas de velocidade.</p><h2>Abordagem destemida</h2><p>O esqui de velocidade exige coragem, e Kriechmayr a entrega.</p><h2>Heranca do esqui austriaco</h2><p>A Austria produziu muitos dos maiores campeoes do esqui, e Kriechmayr continua essa tradicao.</p><h2>Velocidade tecnica</h2><p>Ao contrario dos esquiadores de pura potencia, Kriechmayr combina velocidade com precisao tecnica.</p><h2>Competidor consistente</h2><p>Alem das medalhas de campeonato, Kriechmayr acumulou numerosos podios e vitorias na Copa do Mundo.</p><h2>Competicao no topo</h2><p>Kriechmayr compete contra os melhores do esqui de velocidade, incluindo <a href=\"/aleksander-aamodt-kilde-alpine-skiing-profile/\">Aleksander Aamodt Kilde</a>.</p><h2>Metas futuras</h2><p>Com o ouro mundial ja garantido, Kriechmayr continua perseguindo titulos da Copa do Mundo.</p>",
        "nl": "<p>Vincent Kriechmayr vertegenwoordigt het beste van de Oostenrijkse <a href=\"/alpine-skiing-guide/\">alpineski</a>-traditie. De snelheidsspecialist heeft WK-goud gewonnen in zowel afdaling als super-G.</p><h2>Dubbel wereldkampioen</h2><p>Op het WK 2021 in Cortina behaalde Kriechmayr iets speciaals. Hij won goud in beide snelheidsdisciplines.</p><h2>Onverschrokken aanpak</h2><p>Snelheidsskieen vereist moed, en Kriechmayr levert.</p><h2>Oostenrijkse ski-erfenis</h2><p>Oostenrijk heeft veel van de grootste skikampioenen voortgebracht, en Kriechmayr zet deze traditie voort.</p><h2>Technische snelheid</h2><p>Anders dan pure krachtskieers combineert Kriechmayr snelheid met technische precisie.</p><h2>Consistente concurrent</h2><p>Naast kampioenschapsmedailles heeft Kriechmayr talloze Wereldbeker-podiums en overwinningen verzameld.</p><h2>Competitie aan de top</h2><p>Kriechmayr concurreert tegen de besten in snelheidsskieen, waaronder <a href=\"/aleksander-aamodt-kilde-alpine-skiing-profile/\">Aleksander Aamodt Kilde</a>.</p><h2>Toekomstige doelen</h2><p>Met WK-goud al verzekerd, blijft Kriechmayr Wereldbeker-titels najagen.</p>",
        "ar": "<p>يمثل فينسنت كريشماير أفضل تقاليد <a href=\"/alpine-skiing-guide/\">التزلج الألبي</a> النمساوية. فاز متخصص السرعة بذهبيات عالمية في الانحدار والسوبر جي.</p><h2>بطل عالمي مزدوج</h2><p>في بطولة العالم 2021 في كورتينا، حقق كريشماير شيئاً مميزاً. فاز بالذهب في كلا تخصصي السرعة.</p><h2>نهج جريء</h2><p>يتطلب تزلج السرعة الشجاعة، وكريشماير يقدمها.</p><h2>إرث التزلج النمساوي</h2><p>أنتجت النمسا العديد من أعظم أبطال التزلج، وكريشماير يواصل هذا التقليد.</p><h2>سرعة تقنية</h2><p>على عكس متزلجي القوة الخالصة، يجمع كريشماير بين السرعة والدقة التقنية.</p><h2>منافس مستمر</h2><p>بخلاف ميداليات البطولة، جمع كريشماير العديد من منصات كأس العالم والانتصارات.</p><h2>منافسة في القمة</h2><p>يتنافس كريشماير ضد أفضل متزلجي السرعة، بما في ذلك <a href=\"/aleksander-aamodt-kilde-alpine-skiing-profile/\">ألكسندر أموت كيلدا</a>.</p><h2>الأهداف المستقبلية</h2><p>مع ضمان الذهب العالمي، يواصل كريشماير السعي لألقاب كأس العالم.</p>",
        "ja": "<p>ヴィンセント・クリーヒマイヤーはオーストリアの<a href=\"/alpine-skiing-guide/\">アルペンスキー</a>伝統の最高を代表します。このスピードスペシャリストはダウンヒルとスーパーGの両方で世界選手権金メダルを獲得しました。</p><h2>二冠王者</h2><p>2021年コルティナ世界選手権で、クリーヒマイヤーは特別なことを達成しました。両方のスピード種目で金メダルを獲得しました。</p><h2>恐れを知らないアプローチ</h2><p>スピードスキーには勇気が必要で、クリーヒマイヤーはそれを発揮します。</p><h2>オーストリアスキーの遺産</h2><p>オーストリアはスキーの偉大なチャンピオンを多く輩出し、クリーヒマイヤーはこの伝統を継続しています。</p><h2>技術的スピード</h2><p>純粋なパワースキーヤーと異なり、クリーヒマイヤーはスピードと技術的精度を組み合わせます。</p><h2>安定した競技者</h2><p>選手権メダルを超えて、クリーヒマイヤーは多くのワールドカップ表彰台と勝利を蓄積しています。</p><h2>トップでの競争</h2><p>クリーヒマイヤーは<a href=\"/aleksander-aamodt-kilde-alpine-skiing-profile/\">アレクサンダー・オモット・キルデ</a>を含むスピードスキーの最高と競います。</p><h2>将来の目標</h2><p>世界選手権金を確保し、クリーヒマイヤーはワールドカップタイトルを追求し続けています。</p>",
        "zh": "<p>Vincent Kriechmayr daibiao Aodili <a href=\"/alpine-skiing-guide/\">gaoshan huaxue</a> chuantong de zuihao. Zhe wei sudu zhuanjia zai suxiang he chaojidashuixuan zhong huode shijie jinbiaosai jinpai.</p><h2>Shuang guan junwang</h2><p>Zai 2021 nian Cortina shijie jinbiaosai shang, Kriechmayr wancheng le teshu de chengjiu. Ta zai liang ge sudu xiangmu zhong dou huode jinpai.</p><h2>Wuwei de fangfa</h2><p>Sudu huaxue xuyao yongqi, Kriechmayr tixian le zhe yidian.</p><h2>Aodili huaxue yichan</h2><p>Aodili chansheng le xuduo huaxue de weida guanjun, Kriechmayr yanxu zhe yi chuantong.</p><h2>Jishu sudu</h2><p>Yu chunli liangxuezhe butong, Kriechmayr jiangli sudu yu jishu jingzhun xiangjiehe.</p><h2>Wending de jingzhengzhe</h2><p>Chule jinbiaosai jiangpai, Kriechmayr haijilei le zhongduo shijie bei lingjiangtai he shengli.</p><h2>Dingji jingzheng</h2><p>Kriechmayr yu sudu huaxue de zuijia jingzheng, baokuo <a href=\"/aleksander-aamodt-kilde-alpine-skiing-profile/\">Aleksander Aamodt Kilde</a>.</p><h2>Weilai mubiao</h2><p>Yi quede shijie jinbiaosai jinpai, Kriechmayr jixu zhuiqiu shijie bei guanjun.</p>",
        "ko": "<p>빈센트 크리히마이어는 오스트리아 <a href=\"/alpine-skiing-guide/\">알파인 스키</a> 전통의 최고를 대표합니다. 이 스피드 스페셜리스트는 다운힐과 슈퍼-G 모두에서 세계선수권 금메달을 획득했습니다.</p><h2>더블 세계 챔피언</h2><p>2021년 코르티나 세계선수권에서 크리히마이어는 특별한 것을 달성했습니다. 두 스피드 종목 모두에서 금메달을 획득했습니다.</p><h2>두려움 없는 접근</h2><p>스피드 스키에는 용기가 필요하며, 크리히마이어는 그것을 보여줍니다.</p><h2>오스트리아 스키 유산</h2><p>오스트리아는 스키의 위대한 챔피언을 많이 배출했으며, 크리히마이어는 이 전통을 이어갑니다.</p><h2>기술적 스피드</h2><p>순수한 파워 스키어와 달리 크리히마이어는 스피드와 기술적 정밀함을 결합합니다.</p><h2>일관된 경쟁자</h2><p>선수권 메달을 넘어 크리히마이어는 수많은 월드컵 포디움과 승리를 축적했습니다.</p><h2>정상에서의 경쟁</h2><p>크리히마이어는 <a href=\"/aleksander-aamodt-kilde-alpine-skiing-profile/\">알렉산더 오모트 킬데</a>를 포함한 스피드 스키 최고와 경쟁합니다.</p><h2>미래 목표</h2><p>세계선수권 금메달을 확보하고 크리히마이어는 월드컵 타이틀을 계속 추구합니다.</p>"
    }'::jsonb,
    'athlete-profile',
    'AS',
    '{
        "en": "Profile of Vincent Kriechmayr, Austria''s speed skiing champion with World Championship gold medals in downhill and super-G.",
        "de": "Profil von Vincent Kriechmayr, Oesterreichs Geschwindigkeitsskikoenig mit WM-Goldmedaillen in Abfahrt und Super-G.",
        "fr": "Profil de Vincent Kriechmayr, le champion autrichien de vitesse avec des ors mondiaux en descente et super-G.",
        "it": "Profilo di Vincent Kriechmayr, il campione austriaco della velocita con ori mondiali in discesa e super-G.",
        "es": "Perfil de Vincent Kriechmayr, el campeon austriaco de velocidad con oros mundiales en descenso y super-G.",
        "pt": "Perfil de Vincent Kriechmayr, o campeao austriaco de velocidade com ouros mundiais em descida e super-G.",
        "nl": "Profiel van Vincent Kriechmayr, de Oostenrijkse snelheidskampioen met WK-goud in afdaling en super-G.",
        "ar": "ملف فينسنت كريشماير، بطل السرعة النمساوي بذهبيات عالمية في الانحدار والسوبر جي.",
        "ja": "ダウンヒルとスーパーGで世界選手権金メダルを持つオーストリアのスピードスキーチャンピオン、ヴィンセント・クリーヒマイヤーのプロフィール。",
        "zh": "Vincent Kriechmayr de jianjie, zai suxiang he chaojidashuixuan zhong huode shijie jinbiaosai jinpai de Aodili sudu huaxue guanjun.",
        "ko": "다운힐과 슈퍼-G에서 세계선수권 금메달을 획득한 오스트리아의 스피드 스키 챔피언 빈센트 크리히마이어의 프로필."
    }'::jsonb,
    'published',
    NOW(),
    'evergreen'
) ON CONFLICT (slug) DO UPDATE SET
    title = EXCLUDED.title,
    excerpt = EXCLUDED.excerpt,
    content = EXCLUDED.content,
    meta_description = EXCLUDED.meta_description,
    updated_at = NOW();

-- Track image requirement
INSERT INTO article_images (article_slug, image_type, description, status)
VALUES (
    'vincent-kriechmayr-alpine-skiing-profile',
    'featured',
    'Vincent Kriechmayr racing downhill, Austrian colors, tucked position at high speed',
    'pending'
) ON CONFLICT (article_slug, image_type) DO NOTHING;
