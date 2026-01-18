-- Migration: 034_athlete_eoberg.sql
-- Athlete Profile: Elvira Oberg (Swedish Biathlon)
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
    'elvira-oberg-biathlon-profile',
    '{
        "en": "Elvira Oberg: Sweden''s Biathlon Rising Star",
        "de": "Elvira Oberg: Schwedens aufgehender Biathlon-Stern",
        "fr": "Elvira Oberg: L''etoile montante suedoise du biathlon",
        "it": "Elvira Oberg: La stella nascente svedese del biathlon",
        "es": "Elvira Oberg: La estrella emergente sueca del biatlon",
        "pt": "Elvira Oberg: A estrela em ascensao sueca do biatlo",
        "nl": "Elvira Oberg: De rijzende Zweedse biatlon ster",
        "ar": "إلفيرا أوبيرغ: نجمة البياثلون السويدية الصاعدة",
        "ja": "エルヴィラ・エーベリ：スウェーデンバイアスロンの新星",
        "zh": "Elvira Oberg: Ruidian dongji liangxiang xinxing",
        "ko": "엘비라 외베르크: 스웨덴 바이애슬론의 떠오르는 스타"
    }'::jsonb,
    '{
        "en": "The young Swedish biathlete who has emerged as a World Cup force with exceptional skiing speed and improving shooting accuracy.",
        "de": "Die junge schwedische Biathletin, die mit aussergewoehnlicher Skigeschwindigkeit und verbesserter Schiessgenauigkeit zur Weltcup-Kraft geworden ist.",
        "fr": "La jeune biathlonienne suedoise qui s''est imposee comme une force de la Coupe du monde avec une vitesse exceptionnelle.",
        "it": "La giovane biatleta svedese che si e affermata come forza della Coppa del Mondo con velocita eccezionale.",
        "es": "La joven biatleta sueca que ha surgido como fuerza de la Copa del Mundo con velocidad excepcional.",
        "pt": "A jovem biatleta sueca que emergiu como forca da Copa do Mundo com velocidade excepcional.",
        "nl": "De jonge Zweedse biatlete die is opgekomen als Wereldbeker-kracht met uitzonderlijke skisnelheid.",
        "ar": "لاعبة البياثلون السويدية الشابة التي برزت كقوة في كأس العالم بسرعة تزلج استثنائية",
        "ja": "卓越したスキー速度でワールドカップの力として台頭した若いスウェーデンのバイアスロン選手",
        "zh": "Yi chuzhong de huaxue sudu chengwei shijie bei liliang de nianqing Ruidian dongji liangxiang xuanshou",
        "ko": "뛰어난 스키 속도로 월드컵 강자로 부상한 젊은 스웨덴 바이애슬론 선수"
    }'::jsonb,
    '{
        "en": "<p>Elvira Oberg has quickly risen to become one of the most exciting athletes in <a href=\"/biathlon-guide/\">biathlon</a>. The young Swedish star combines exceptional cross-country skiing speed with rapidly improving shooting to challenge the established elite on the World Cup circuit.</p><h2>The Oberg Sisters</h2><p>Elvira is part of a biathlon sister duo that has taken Swedish sports by storm. Her older sister Hanna also competes at the World Cup level, creating a family dynamic that pushes both athletes to excellence. Together, they have helped elevate Swedish women''s biathlon to new heights.</p><h2>Skiing Speed Advantage</h2><p>What sets Elvira apart is her cross-country skiing ability. She regularly posts the fastest skiing times in races, making up ground even when shooting costs her time. This speed comes from a strong endurance background and efficient technique that allows her to maintain pace throughout races.</p><h2>Shooting Development</h2><p>While skiing has always been Elvira''s strength, her shooting has improved dramatically. Early in her career, missed shots cost valuable time and positions. Now, her accuracy has increased to the point where she can challenge for victories rather than just fast skiing times.</p><h2>World Cup Breakthrough</h2><p>Elvira claimed World Cup victories that announced her arrival among the elite. Her ability to win against established champions like <a href=\"/dorothea-wierer-biathlon-profile/\">Dorothea Wierer</a> and others demonstrated she belongs at the top. These wins came through a combination of fast skiing and improved shooting accuracy.</p><h2>Championship Aspirations</h2><p>With World Cup success established, Elvira now targets World Championship medals. Major championships require peak performance under extreme pressure, and she continues developing the mental skills needed to excel at these events.</p><h2>Future Potential</h2><p>At her young age, Elvira has years of development ahead. If she continues improving her shooting while maintaining her exceptional skiing speed, she could become one of the most dominant biathletes of her generation. Swedish fans anticipate many more victories in her future.</p>",
        "de": "<p>Elvira Oberg ist schnell zu einer der aufregendsten Athletinnen im <a href=\"/biathlon-guide/\">Biathlon</a> aufgestiegen. Der junge schwedische Star kombiniert aussergewoehnliche Skigeschwindigkeit mit schnell verbessertem Schiessen.</p><h2>Die Oberg-Schwestern</h2><p>Elvira ist Teil eines Biathlon-Schwesterduos, das den schwedischen Sport im Sturm erobert hat.</p><h2>Vorteil Skigeschwindigkeit</h2><p>Was Elvira auszeichnet, ist ihre Skilanglauf-Faehigkeit. Sie postet regelmaessig die schnellsten Skifahrzeiten.</p><h2>Schiess-Entwicklung</h2><p>Waehrend Skifahren immer Elviras Staerke war, hat sich ihr Schiessen dramatisch verbessert.</p><h2>Weltcup-Durchbruch</h2><p>Elvira holte Weltcup-Siege, die ihre Ankunft unter der Elite ankuendigten.</p><h2>Meisterschafts-Ambitionen</h2><p>Mit etabliertem Weltcup-Erfolg zielt Elvira nun auf WM-Medaillen.</p><h2>Zukunftspotenzial</h2><p>In ihrem jungen Alter hat Elvira Jahre der Entwicklung vor sich.</p>",
        "fr": "<p>Elvira Oberg s''est rapidement elevee pour devenir l''une des athletes les plus excitantes du <a href=\"/biathlon-guide/\">biathlon</a>. La jeune star suedoise combine une vitesse exceptionnelle en ski de fond avec un tir en rapide amelioration.</p><h2>Les soeurs Oberg</h2><p>Elvira fait partie d''un duo de soeurs biatloniennes qui a pris le sport suedois d''assaut.</p><h2>Avantage de vitesse en ski</h2><p>Ce qui distingue Elvira est sa capacite en ski de fond. Elle affiche regulierement les temps de ski les plus rapides.</p><h2>Developpement du tir</h2><p>Alors que le ski a toujours ete la force d''Elvira, son tir s''est ameliore de facon spectaculaire.</p><h2>Percee en Coupe du monde</h2><p>Elvira a remporte des victoires en Coupe du monde qui ont annonce son arrivee parmi l''elite.</p><h2>Ambitions de championnat</h2><p>Avec le succes en Coupe du monde etabli, Elvira vise maintenant les medailles mondiales.</p><h2>Potentiel futur</h2><p>A son jeune age, Elvira a des annees de developpement devant elle.</p>",
        "it": "<p>Elvira Oberg si e rapidamente affermata come una delle atlete piu entusiasmanti del <a href=\"/biathlon-guide/\">biathlon</a>. La giovane star svedese combina una velocita eccezionale nello sci di fondo con un tiro in rapido miglioramento.</p><h2>Le sorelle Oberg</h2><p>Elvira fa parte di un duo di sorelle biatleta che ha preso d''assalto lo sport svedese.</p><h2>Vantaggio di velocita nello sci</h2><p>Cio che distingue Elvira e la sua abilita nello sci di fondo.</p><h2>Sviluppo del tiro</h2><p>Mentre lo sci e sempre stato la forza di Elvira, il suo tiro e migliorato notevolmente.</p><h2>Svolta in Coppa del Mondo</h2><p>Elvira ha conquistato vittorie in Coppa del Mondo che hanno annunciato il suo arrivo tra l''elite.</p><h2>Ambizioni di campionato</h2><p>Con il successo in Coppa del Mondo consolidato, Elvira ora punta alle medaglie mondiali.</p><h2>Potenziale futuro</h2><p>Alla sua giovane eta, Elvira ha anni di sviluppo davanti a se.</p>",
        "es": "<p>Elvira Oberg ha ascendido rapidamente para convertirse en una de las atletas mas emocionantes del <a href=\"/biathlon-guide/\">biatlon</a>. La joven estrella sueca combina velocidad excepcional en esqui de fondo con tiro en rapida mejora.</p><h2>Las hermanas Oberg</h2><p>Elvira es parte de un duo de hermanas biatletas que ha tomado por asalto el deporte sueco.</p><h2>Ventaja de velocidad en esqui</h2><p>Lo que distingue a Elvira es su habilidad en esqui de fondo.</p><h2>Desarrollo del tiro</h2><p>Mientras el esqui siempre ha sido la fortaleza de Elvira, su tiro ha mejorado dramaticamente.</p><h2>Avance en Copa del Mundo</h2><p>Elvira logro victorias en Copa del Mundo que anunciaron su llegada a la elite.</p><h2>Ambiciones de campeonato</h2><p>Con el exito en Copa del Mundo establecido, Elvira ahora apunta a medallas mundiales.</p><h2>Potencial futuro</h2><p>A su joven edad, Elvira tiene anos de desarrollo por delante.</p>",
        "pt": "<p>Elvira Oberg subiu rapidamente para se tornar uma das atletas mais emocionantes do <a href=\"/biathlon-guide/\">biatlo</a>. A jovem estrela sueca combina velocidade excepcional no esqui cross-country com tiro em rapida melhoria.</p><h2>As irmas Oberg</h2><p>Elvira faz parte de uma dupla de irmas biatletas que tomou de assalto o esporte sueco.</p><h2>Vantagem de velocidade no esqui</h2><p>O que distingue Elvira e sua habilidade no esqui cross-country.</p><h2>Desenvolvimento do tiro</h2><p>Enquanto o esqui sempre foi a forca de Elvira, seu tiro melhorou dramaticamente.</p><h2>Avanco na Copa do Mundo</h2><p>Elvira conquistou vitorias na Copa do Mundo que anunciaram sua chegada a elite.</p><h2>Ambicoes de campeonato</h2><p>Com o sucesso na Copa do Mundo estabelecido, Elvira agora visa medalhas mundiais.</p><h2>Potencial futuro</h2><p>Em sua jovem idade, Elvira tem anos de desenvolvimento pela frente.</p>",
        "nl": "<p>Elvira Oberg is snel opgestegen tot een van de meest opwindende atleten in <a href=\"/biathlon-guide/\">biatlon</a>. De jonge Zweedse ster combineert uitzonderlijke langlaufsnelheid met snel verbeterend schieten.</p><h2>De Oberg-zussen</h2><p>Elvira maakt deel uit van een biatlon-zussenduo dat de Zweedse sport stormenderhand heeft veroverd.</p><h2>Voordeel skisnelheid</h2><p>Wat Elvira onderscheidt is haar langlaufvaardigheid.</p><h2>Schietontwikkeling</h2><p>Terwijl skieen altijd Elvira''s kracht was, is haar schieten dramatisch verbeterd.</p><h2>Wereldbeker-doorbraak</h2><p>Elvira behaalde Wereldbeker-overwinningen die haar aankomst onder de elite aankondigden.</p><h2>Kampioenschapsambities</h2><p>Met Wereldbeker-succes gevestigd, richt Elvira zich nu op WK-medailles.</p><h2>Toekomstig potentieel</h2><p>Op haar jonge leeftijd heeft Elvira jaren van ontwikkeling voor zich.</p>",
        "ar": "<p>ارتقت إلفيرا أوبيرغ بسرعة لتصبح واحدة من أكثر الرياضيات إثارة في <a href=\"/biathlon-guide/\">البياثلون</a>. تجمع النجمة السويدية الشابة بين سرعة تزلج استثنائية وتصويب يتحسن بسرعة.</p><h2>شقيقتا أوبيرغ</h2><p>إلفيرا جزء من ثنائي شقيقتين في البياثلون اجتاح الرياضة السويدية.</p><h2>ميزة سرعة التزلج</h2><p>ما يميز إلفيرا هو قدرتها على التزلج الريفي.</p><h2>تطور الرماية</h2><p>بينما كان التزلج دائماً قوة إلفيرا، تحسنت رمايتها بشكل كبير.</p><h2>اختراق كأس العالم</h2><p>حققت إلفيرا انتصارات في كأس العالم أعلنت وصولها بين النخبة.</p><h2>طموحات البطولة</h2><p>مع تحقيق النجاح في كأس العالم، تستهدف إلفيرا الآن ميداليات عالمية.</p><h2>الإمكانات المستقبلية</h2><p>في سنها الصغير، لدى إلفيرا سنوات من التطور أمامها.</p>",
        "ja": "<p>エルヴィラ・エーベリは<a href=\"/biathlon-guide/\">バイアスロン</a>で最もエキサイティングな選手の一人に急速に成長しました。若いスウェーデンのスターは、卓越したクロスカントリースキー速度と急速に向上する射撃を組み合わせています。</p><h2>エーベリ姉妹</h2><p>エルヴィラはスウェーデンスポーツを席巻したバイアスロン姉妹デュオの一員です。</p><h2>スキー速度の優位性</h2><p>エルヴィラを際立たせているのはクロスカントリースキー能力です。</p><h2>射撃の発展</h2><p>スキーは常にエルヴィラの強みでしたが、射撃は劇的に向上しました。</p><h2>ワールドカップブレークスルー</h2><p>エルヴィラはエリートへの到着を告げるワールドカップ勝利を達成しました。</p><h2>選手権への野望</h2><p>ワールドカップでの成功を確立し、エルヴィラは今や世界選手権メダルを目指しています。</p><h2>将来の可能性</h2><p>若い年齢で、エルヴィラには発展の年月があります。</p>",
        "zh": "<p>Elvira Oberg xunsu chengzhang wei <a href=\"/biathlon-guide/\">dongji liangxiang</a> zhong zui lingren xingfen de yundongyuan zhiyi. Nianqing de Ruidian mingxing jiangli chuzhong de yueye huaxue sudu yu kuaisu tigao de sheji xiangjiehe.</p><h2>Oberg jiemei</h2><p>Elvira shi xijuan Ruidian tiyu de dongji liangxiang jiemei shuangda de yibufen.</p><h2>Huaxue sudu youshi</h2><p>Shi Elvira tuchu de shi ta de yueye huaxue nengli.</p><h2>Sheji fazhan</h2><p>Suiran huaxue yizhi shi Elvira de qiangxiang, dan ta de sheji yi xianzhu tigao.</p><h2>Shijie bei tupo</h2><p>Elvira huode shijie bei shengli, xuanbu ta jinru jingying hanlie.</p><h2>Jinbiaosai zhuiqiu</h2><p>Zai shijie bei chenggong de jichu shang, Elvira xianzai mubiao shi shijie jinbiaosai jiangpai.</p><h2>Weilai qianli</h2><p>Zai ta nianqing de nianji, Elvira hai you duo nian fazhan.</p>",
        "ko": "<p>엘비라 외베르크는 <a href=\"/biathlon-guide/\">바이애슬론</a>에서 가장 흥미로운 선수 중 하나로 빠르게 성장했습니다. 젊은 스웨덴 스타는 뛰어난 크로스컨트리 스키 속도와 빠르게 향상되는 사격을 결합합니다.</p><h2>외베르크 자매</h2><p>엘비라는 스웨덴 스포츠를 휩쓴 바이애슬론 자매 듀오의 일원입니다.</p><h2>스키 속도 우위</h2><p>엘비라를 차별화하는 것은 크로스컨트리 스키 능력입니다.</p><h2>사격 발전</h2><p>스키가 항상 엘비라의 강점이었지만, 사격은 극적으로 향상되었습니다.</p><h2>월드컵 돌파</h2><p>엘비라는 엘리트로의 도착을 알리는 월드컵 승리를 달성했습니다.</p><h2>선수권 야망</h2><p>월드컵 성공을 확립하고 엘비라는 이제 세계선수권 메달을 목표로 합니다.</p><h2>미래 잠재력</h2><p>젊은 나이에 엘비라는 앞으로 수년간의 발전이 있습니다.</p>"
    }'::jsonb,
    'athlete-profile',
    'BT',
    '{
        "en": "Profile of Elvira Oberg, Sweden''s biathlon rising star with exceptional skiing speed and World Cup victories.",
        "de": "Profil von Elvira Oberg, Schwedens aufgehender Biathlon-Stern mit aussergewoehnlicher Skigeschwindigkeit und Weltcup-Siegen.",
        "fr": "Profil d''Elvira Oberg, l''etoile montante suedoise du biathlon avec une vitesse exceptionnelle et des victoires en Coupe du monde.",
        "it": "Profilo di Elvira Oberg, la stella nascente svedese del biathlon con velocita eccezionale e vittorie in Coppa del Mondo.",
        "es": "Perfil de Elvira Oberg, la estrella emergente sueca del biatlon con velocidad excepcional y victorias en Copa del Mundo.",
        "pt": "Perfil de Elvira Oberg, a estrela em ascensao sueca do biatlo com velocidade excepcional e vitorias na Copa do Mundo.",
        "nl": "Profiel van Elvira Oberg, de rijzende Zweedse biatlon ster met uitzonderlijke skisnelheid en Wereldbeker-overwinningen.",
        "ar": "ملف إلفيرا أوبيرغ، نجمة البياثلون السويدية الصاعدة بسرعة تزلج استثنائية وانتصارات كأس العالم.",
        "ja": "卓越したスキー速度とワールドカップ勝利を持つスウェーデンバイアスロンの新星、エルヴィラ・エーベリのプロフィール。",
        "zh": "Elvira Oberg de jianjie, yongyou chuzhong huaxue sudu he shijie bei shengli de Ruidian dongji liangxiang xinxing.",
        "ko": "뛰어난 스키 속도와 월드컵 승리를 가진 스웨덴 바이애슬론의 떠오르는 스타 엘비라 외베르크의 프로필."
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
    'elvira-oberg-biathlon-profile',
    'featured',
    'Elvira Oberg skiing fast in biathlon race, Swedish colors, determination visible',
    'pending'
) ON CONFLICT (article_slug, image_type) DO NOTHING;
