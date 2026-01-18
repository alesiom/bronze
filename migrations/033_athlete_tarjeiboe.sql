-- Migration: 033_athlete_tarjeiboe.sql
-- Athlete Profile: Tarjei Boe (Norwegian Biathlon)
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
    'tarjei-boe-biathlon-profile',
    '{
        "en": "Tarjei Boe: The Original Boe Brother",
        "de": "Tarjei Boe: Der urspruengliche Boe-Bruder",
        "fr": "Tarjei Boe: Le frere Boe original",
        "it": "Tarjei Boe: Il fratello Boe originale",
        "es": "Tarjei Boe: El hermano Boe original",
        "pt": "Tarjei Boe: O irmao Boe original",
        "nl": "Tarjei Boe: De originele Boe broer",
        "ar": "تارجي بو: شقيق بو الأصلي",
        "ja": "タルヤイ・ボー：オリジナルのボー兄弟",
        "zh": "Tarjei Boe: Yuanshi de Boe xiongdi",
        "ko": "타르예이 뵈: 원조 뵈 형제"
    }'::jsonb,
    '{
        "en": "The elder Boe brother who paved the way in Norwegian biathlon and continues to compete at the highest level alongside his brother Johannes.",
        "de": "Der aeltere Boe-Bruder, der den Weg im norwegischen Biathlon ebnete und weiterhin auf hoechstem Niveau antritt.",
        "fr": "Le frere aine Boe qui a ouvert la voie dans le biathlon norvegien et continue de concourir au plus haut niveau.",
        "it": "Il fratello maggiore Boe che ha aperto la strada nel biathlon norvegese e continua a competere al massimo livello.",
        "es": "El hermano mayor Boe que abrio el camino en el biatlon noruego y continua compitiendo al mas alto nivel.",
        "pt": "O irmao mais velho Boe que abriu caminho no biatlo noruegues e continua competindo no mais alto nivel.",
        "nl": "De oudere Boe broer die de weg baande in het Noorse biatlon en blijft concurreren op het hoogste niveau.",
        "ar": "الشقيق الأكبر بو الذي مهد الطريق في البياثلون النرويجي ويواصل المنافسة على أعلى مستوى",
        "ja": "ノルウェーバイアスロンで道を切り開き、弟のヨハネスと共に最高レベルで競い続ける兄ボー",
        "zh": "Zai Nuowei dongji liangxiang zhong kaipi daolude nianzhang Boe xiongdi, jixu yu didi Johannes yiqi zai zuigao shuiping jingzheng",
        "ko": "노르웨이 바이애슬론에서 길을 닦고 동생 요하네스와 함께 최고 수준에서 경쟁을 계속하는 형 뵈"
    }'::jsonb,
    '{
        "en": "<p>Tarjei Boe was a <a href=\"/biathlon-guide/\">biathlon</a> star before his younger brother <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a> rose to dominate the sport. The elder Boe has carved out his own impressive career with World Championship gold medals and World Cup victories, and continues to be a force on the circuit.</p><h2>The First Boe Star</h2><p>Before Johannes became the most successful biathlete in history, Tarjei was already winning at the highest level. He claimed World Championship gold and established himself as one of the best in the sport. His success helped inspire Johannes to pursue biathlon, creating the dominant family dynasty Norway knows today.</p><h2>World Championship Success</h2><p>Tarjei has won multiple World Championship medals, including gold in individual and relay events. These performances at the sport''s biggest championships demonstrate his ability to perform when pressure is highest. He has consistently delivered in the most important competitions throughout his career.</p><h2>Shooting Specialist</h2><p>Tarjei is known for his shooting accuracy. His calm approach at the range leads to clean shooting stages that keep him competitive. While his skiing speed may not match the very fastest, his reliability on the shooting range compensates and often makes the difference in races.</p><h2>Brother Dynamics</h2><p>Racing alongside and often against his younger brother Johannes creates unique dynamics. The brothers push each other to improve while also competing for the same victories. They have shared podiums and relay success, demonstrating how family competition can drive excellence. Tarjei handles the pressure of being compared to his record-breaking brother with grace.</p><h2>Team Contributor</h2><p>Beyond individual success, Tarjei has been crucial to Norwegian relay teams. His steady performances provide a reliable foundation that helps Norway dominate team events. World Championship and World Cup relay victories have come with Tarjei as a key team member.</p><h2>Longevity</h2><p>Tarjei''s career demonstrates remarkable longevity at the top level. While many athletes fade as they age, he continues to compete for podiums and victories. His experience and race craft compensate for any small decline in physical peak, keeping him competitive against younger athletes.</p><h2>Role Model</h2><p>For young biathletes, Tarjei shows that sustained excellence is possible. His career provides a model of how to maintain motivation and performance over many seasons. Norwegian biathlon''s depth owes something to athletes like Tarjei who demonstrate what dedication can achieve.</p>",
        "de": "<p>Tarjei Boe war ein <a href=\"/biathlon-guide/\">Biathlon</a>-Star, bevor sein juengerer Bruder <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a> aufstieg, um den Sport zu dominieren. Der aeltere Boe hat seine eigene beeindruckende Karriere mit WM-Gold und Weltcup-Siegen aufgebaut.</p><h2>Der erste Boe-Star</h2><p>Bevor Johannes der erfolgreichste Biathlet der Geschichte wurde, gewann Tarjei bereits auf hoechstem Niveau.</p><h2>WM-Erfolge</h2><p>Tarjei hat mehrere WM-Medaillen gewonnen, darunter Gold in Einzel- und Staffelwettbewerben.</p><h2>Schiess-Spezialist</h2><p>Tarjei ist fuer seine Schiessgenauigkeit bekannt.</p><h2>Brueder-Dynamik</h2><p>Neben und oft gegen seinen juengeren Bruder Johannes zu fahren, schafft einzigartige Dynamiken.</p><h2>Team-Beitraeger</h2><p>Ueber den Einzelerfolg hinaus war Tarjei entscheidend fuer norwegische Staffelteams.</p><h2>Langlebigkeit</h2><p>Tarjeis Karriere zeigt bemerkenswerte Langlebigkeit auf hoechstem Niveau.</p><h2>Vorbild</h2><p>Fuer junge Biathleten zeigt Tarjei, dass nachhaltige Exzellenz moeglich ist.</p>",
        "fr": "<p>Tarjei Boe etait une star du <a href=\"/biathlon-guide/\">biathlon</a> avant que son jeune frere <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a> ne s''eleve pour dominer le sport. Le frere aine a forge sa propre carriere impressionnante avec des medailles d''or mondiales et des victoires en Coupe du monde.</p><h2>La premiere star Boe</h2><p>Avant que Johannes ne devienne le biathlonien le plus titré de l''histoire, Tarjei gagnait deja au plus haut niveau.</p><h2>Succes aux Championnats du monde</h2><p>Tarjei a remporte plusieurs medailles mondiales, dont l''or en individuel et en relais.</p><h2>Specialiste du tir</h2><p>Tarjei est connu pour sa precision au tir.</p><h2>Dynamique fraternelle</h2><p>Courir aux cotes et souvent contre son jeune frere Johannes cree des dynamiques uniques.</p><h2>Contributeur d''equipe</h2><p>Au-dela du succes individuel, Tarjei a ete crucial pour les equipes norvégiennes de relais.</p><h2>Longevite</h2><p>La carriere de Tarjei demontre une longevite remarquable au plus haut niveau.</p><h2>Modele</h2><p>Pour les jeunes biathletés, Tarjei montre que l''excellence soutenue est possible.</p>",
        "it": "<p>Tarjei Boe era una star del <a href=\"/biathlon-guide/\">biathlon</a> prima che il fratello minore <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a> emergesse per dominare lo sport. Il fratello maggiore ha costruito la propria impressionante carriera con ori mondiali e vittorie in Coppa del Mondo.</p><h2>La prima stella Boe</h2><p>Prima che Johannes diventasse il biatleta di maggior successo della storia, Tarjei vinceva gia al massimo livello.</p><h2>Successo ai Mondiali</h2><p>Tarjei ha vinto diverse medaglie mondiali, incluso l''oro in gare individuali e staffette.</p><h2>Specialista del tiro</h2><p>Tarjei e noto per la sua precisione nel tiro.</p><h2>Dinamiche fraterne</h2><p>Gareggiare accanto e spesso contro il fratello minore Johannes crea dinamiche uniche.</p><h2>Contributore di squadra</h2><p>Oltre al successo individuale, Tarjei e stato cruciale per le squadre norvegesi di staffetta.</p><h2>Longevita</h2><p>La carriera di Tarjei dimostra notevole longevita al massimo livello.</p><h2>Modello</h2><p>Per i giovani biatleti, Tarjei mostra che l''eccellenza sostenuta e possibile.</p>",
        "es": "<p>Tarjei Boe era una estrella del <a href=\"/biathlon-guide/\">biatlon</a> antes de que su hermano menor <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a> surgiera para dominar el deporte. El hermano mayor ha forjado su propia impresionante carrera con oros mundiales y victorias en Copa del Mundo.</p><h2>La primera estrella Boe</h2><p>Antes de que Johannes se convirtiera en el biatleta mas exitoso de la historia, Tarjei ya estaba ganando al mas alto nivel.</p><h2>Exito en Campeonatos Mundiales</h2><p>Tarjei ha ganado multiples medallas mundiales, incluyendo oro en eventos individuales y de relevos.</p><h2>Especialista en tiro</h2><p>Tarjei es conocido por su precision en el tiro.</p><h2>Dinamica de hermanos</h2><p>Correr junto y a menudo contra su hermano menor Johannes crea dinamicas unicas.</p><h2>Contribuidor de equipo</h2><p>Mas alla del exito individual, Tarjei ha sido crucial para los equipos noruegos de relevos.</p><h2>Longevidad</h2><p>La carrera de Tarjei demuestra notable longevidad al mas alto nivel.</p><h2>Modelo a seguir</h2><p>Para jovenes biatletas, Tarjei muestra que la excelencia sostenida es posible.</p>",
        "pt": "<p>Tarjei Boe era uma estrela do <a href=\"/biathlon-guide/\">biatlo</a> antes de seu irmao mais novo <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a> surgir para dominar o esporte. O irmao mais velho construiu sua propria impressionante carreira com ouros mundiais e vitorias na Copa do Mundo.</p><h2>A primeira estrela Boe</h2><p>Antes de Johannes se tornar o biatleta mais bem-sucedido da historia, Tarjei ja estava vencendo no mais alto nivel.</p><h2>Sucesso em Campeonatos Mundiais</h2><p>Tarjei ganhou multiplas medalhas mundiais, incluindo ouro em eventos individuais e de revezamento.</p><h2>Especialista em tiro</h2><p>Tarjei e conhecido por sua precisao no tiro.</p><h2>Dinamica de irmaos</h2><p>Correr ao lado e muitas vezes contra seu irmao mais novo Johannes cria dinamicas unicas.</p><h2>Contribuidor de equipe</h2><p>Alem do sucesso individual, Tarjei foi crucial para as equipes norueguesas de revezamento.</p><h2>Longevidade</h2><p>A carreira de Tarjei demonstra notavel longevidade no mais alto nivel.</p><h2>Modelo</h2><p>Para jovens biatletas, Tarjei mostra que a excelencia sustentada e possivel.</p>",
        "nl": "<p>Tarjei Boe was een <a href=\"/biathlon-guide/\">biatlon</a>-ster voordat zijn jongere broer <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a> opsteeg om de sport te domineren. De oudere Boe heeft zijn eigen indrukwekkende carriere opgebouwd met WK-goud en Wereldbeker-overwinningen.</p><h2>De eerste Boe-ster</h2><p>Voordat Johannes de meest succesvolle biatleet in de geschiedenis werd, won Tarjei al op het hoogste niveau.</p><h2>WK-succes</h2><p>Tarjei heeft meerdere WK-medailles gewonnen, waaronder goud in individuele en estafette-evenementen.</p><h2>Schietspecialist</h2><p>Tarjei staat bekend om zijn schietnauwkeurigheid.</p><h2>Broerdynamiek</h2><p>Naast en vaak tegen zijn jongere broer Johannes racen creert unieke dynamieken.</p><h2>Teambijdrager</h2><p>Naast individueel succes is Tarjei cruciaal geweest voor Noorse estafetteteams.</p><h2>Levensduur</h2><p>Tarjei''s carriere toont opmerkelijke levensduur op het hoogste niveau.</p><h2>Rolmodel</h2><p>Voor jonge biatleten toont Tarjei dat aanhoudende excellentie mogelijk is.</p>",
        "ar": "<p>كان تارجي بو نجماً في <a href=\"/biathlon-guide/\">البياثلون</a> قبل أن يرتقي شقيقه الأصغر <a href=\"/johannes-thingnes-boe-biathlon-profile/\">يوهانس ثينجنس بو</a> ليهيمن على الرياضة. بنى الشقيق الأكبر مسيرته المثيرة للإعجاب بذهبيات عالمية وانتصارات كأس العالم.</p><h2>نجم بو الأول</h2><p>قبل أن يصبح يوهانس أنجح لاعب بياثلون في التاريخ، كان تارجي يفوز بالفعل على أعلى مستوى.</p><h2>نجاح البطولات العالمية</h2><p>فاز تارجي بعدة ميداليات عالمية، بما في ذلك ذهب في الفردي والتتابع.</p><h2>متخصص الرماية</h2><p>يُعرف تارجي بدقة رمايته.</p><h2>ديناميكية الإخوة</h2><p>السباق بجانب وغالباً ضد شقيقه الأصغر يوهانس يخلق ديناميكيات فريدة.</p><h2>مساهم الفريق</h2><p>بخلاف النجاح الفردي، كان تارجي حاسماً لفرق التتابع النرويجية.</p><h2>طول العمر</h2><p>تُظهر مسيرة تارجي استمرارية ملحوظة على أعلى مستوى.</p><h2>قدوة</h2><p>للاعبي البياثلون الشباب، يُظهر تارجي أن التميز المستدام ممكن.</p>",
        "ja": "<p>タルヤイ・ボーは弟の<a href=\"/johannes-thingnes-boe-biathlon-profile/\">ヨハネス・ティングネス・ボー</a>がスポーツを支配するようになる前から<a href=\"/biathlon-guide/\">バイアスロン</a>のスターでした。兄ボーは世界選手権の金メダルとワールドカップの勝利で独自の印象的なキャリアを築きました。</p><h2>最初のボースター</h2><p>ヨハネスが歴史上最も成功したバイアスリートになる前、タルヤイはすでに最高レベルで勝利していました。</p><h2>世界選手権での成功</h2><p>タルヤイは個人とリレーイベントで金を含む複数の世界選手権メダルを獲得しています。</p><h2>射撃スペシャリスト</h2><p>タルヤイは射撃の正確さで知られています。</p><h2>兄弟のダイナミクス</h2><p>弟ヨハネスと一緒に、そしてしばしば対戦することでユニークなダイナミクスが生まれます。</p><h2>チーム貢献者</h2><p>個人の成功を超えて、タルヤイはノルウェーのリレーチームに不可欠でした。</p><h2>長寿</h2><p>タルヤイのキャリアはトップレベルでの顕著な長寿を示しています。</p><h2>ロールモデル</h2><p>若いバイアスリートにとって、タルヤイは持続的な卓越性が可能であることを示しています。</p>",
        "zh": "<p>Tarjei Boe zai didi <a href=\"/johannes-thingnes-boe-biathlon-profile/\">Johannes Thingnes Boe</a> juqi zhudao yundong zhiqian jiushi <a href=\"/biathlon-guide/\">dongji liangxiang</a> mingxing. Nianzhang de Boe yongyou shijie jinbiaosai jinpai he shijie bei shengli, jianzao le ziji de yinxiang shenke de zhiye shengya.</p><h2>Diyi wei Boe mingxing</h2><p>Zai Johannes chengwei lishi shang zui chenggong de dongji liangxiang xuanshou zhiqian, Tarjei yijing zai zuigao shuiping huode shengli.</p><h2>Shijie jinbiaosai chenggong</h2><p>Tarjei yingle duomei shijie jinbiaosai jiangpai, baokuo geren he jieli xiangmu jinpai.</p><h2>Sheji zhuanjia</h2><p>Tarjei yi sheji jingzhun zhucheng.</p><h2>Xiongdi dongtai</h2><p>Yu didi Johannes yiqi bisai, jingchang shi duikang, chuangzao dute de dongtai.</p><h2>Tuandui gongxianzhe</h2><p>Chule geren chenggong, Tarjei dui Nuowei jieli dui zhiguanzhongyao.</p><h2>Changshou</h2><p>Tarjei de zhiye shengya zhanshi le zai zuigao shuiping de feifan changshou.</p><h2>Bangyang</h2><p>Dui nianqing dongji liangxiang xuanshou, Tarjei zhanshi chixu de zhuoyue shi keneng de.</p>",
        "ko": "<p>타르예이 뵈는 동생 <a href=\"/johannes-thingnes-boe-biathlon-profile/\">요하네스 팅네스 뵈</a>가 스포츠를 지배하기 전부터 <a href=\"/biathlon-guide/\">바이애슬론</a> 스타였습니다. 형 뵈는 세계선수권 금메달과 월드컵 승리로 자신만의 인상적인 커리어를 쌓았습니다.</p><h2>첫 번째 뵈 스타</h2><p>요하네스가 역사상 가장 성공적인 바이애슬리트가 되기 전, 타르예이는 이미 최고 수준에서 승리하고 있었습니다.</p><h2>세계선수권 성공</h2><p>타르예이는 개인과 릴레이 이벤트에서 금을 포함한 여러 세계선수권 메달을 획득했습니다.</p><h2>사격 스페셜리스트</h2><p>타르예이는 사격 정확도로 알려져 있습니다.</p><h2>형제 역학</h2><p>동생 요하네스와 함께, 그리고 종종 맞서 경주하는 것은 독특한 역학을 만듭니다.</p><h2>팀 기여자</h2><p>개인 성공 외에도 타르예이는 노르웨이 릴레이 팀에 결정적이었습니다.</p><h2>장수</h2><p>타르예이의 커리어는 최고 수준에서 놀라운 장수를 보여줍니다.</p><h2>롤모델</h2><p>젊은 바이애슬리트들에게 타르예이는 지속적인 우수성이 가능함을 보여줍니다.</p>"
    }'::jsonb,
    'athlete-profile',
    'BT',
    '{
        "en": "Profile of Tarjei Boe, the elder Boe brother who paved the way in Norwegian biathlon with World Championship gold medals.",
        "de": "Profil von Tarjei Boe, dem aelteren Boe-Bruder, der mit WM-Gold den Weg im norwegischen Biathlon ebnete.",
        "fr": "Profil de Tarjei Boe, le frere aine Boe qui a ouvert la voie dans le biathlon norvegien avec des medailles d''or mondiales.",
        "it": "Profilo di Tarjei Boe, il fratello maggiore Boe che ha aperto la strada nel biathlon norvegese con ori mondiali.",
        "es": "Perfil de Tarjei Boe, el hermano mayor Boe que abrio el camino en el biatlon noruego con oros mundiales.",
        "pt": "Perfil de Tarjei Boe, o irmao mais velho Boe que abriu caminho no biatlo noruegues com ouros mundiais.",
        "nl": "Profiel van Tarjei Boe, de oudere Boe broer die de weg baande in het Noorse biatlon met WK-goud.",
        "ar": "ملف تارجي بو، الشقيق الأكبر بو الذي مهد الطريق في البياثلون النرويجي بذهبيات عالمية.",
        "ja": "世界選手権金メダルでノルウェーバイアスロンの道を切り開いた兄ボー、タルヤイ・ボーのプロフィール。",
        "zh": "Tarjei Boe de jianjie, yi shijie jinbiaosai jinpai zai Nuowei dongji liangxiang zhong kaipi daolu de nianzhang Boe xiongdi.",
        "ko": "세계선수권 금메달로 노르웨이 바이애슬론에서 길을 닦은 형 뵈 타르예이 뵈의 프로필."
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
    'tarjei-boe-biathlon-profile',
    'featured',
    'Tarjei Boe skiing in biathlon race, Norwegian colors, focused expression',
    'pending'
) ON CONFLICT (article_slug, image_type) DO NOTHING;
