-- Migration: Sport Explainer Articles Part 3 (with internal linking)
-- Run with: psql -d neve26 -f migrations/006_sport_explainers_part3.sql

-- ============================================================================
-- 6. Figure Skating Scoring Demystified
-- ============================================================================
INSERT INTO articles (
    slug, title, excerpt, content, category, sport_code,
    meta_description, status, published_at, source_type
) VALUES (
    'figure-skating-scoring-explained',

    '{
        "en": "Figure Skating Scoring Demystified",
        "de": "Eiskunstlauf-Wertung verständlich erklärt",
        "fr": "Le Système de Notation du Patinage Artistique Expliqué",
        "it": "Il Punteggio del Pattinaggio Artistico Spiegato",
        "es": "Puntuación del Patinaje Artístico Explicada",
        "pt": "Pontuação da Patinação Artística Explicada",
        "nl": "Kunstrijden Scoresysteem Uitgelegd",
        "ar": "نظام تسجيل التزلج الفني موضح",
        "ja": "フィギュアスケート採点システム解説",
        "zh": "花样滑冰评分系统解析",
        "ko": "피겨 스케이팅 채점 시스템 설명"
    }'::jsonb,

    '{
        "en": "Understand how figure skaters are scored. Learn about technical elements, program components, jumps like the triple axel, and what judges look for in championship performances.",
        "de": "Verstehen Sie, wie Eiskunstläufer bewertet werden. Erfahren Sie alles über technische Elemente, Programmkomponenten und Sprünge wie den dreifachen Axel.",
        "fr": "Comprenez comment les patineurs artistiques sont notés. Découvrez les éléments techniques, les composantes de programme et les sauts comme le triple axel.",
        "it": "Comprendi come vengono valutati i pattinatori artistici. Scopri elementi tecnici, componenti del programma e salti come il triplo axel.",
        "es": "Entiende cómo se puntúa a los patinadores artísticos. Aprende sobre elementos técnicos, componentes del programa y saltos como el triple axel.",
        "pt": "Entenda como os patinadores artísticos são pontuados. Aprenda sobre elementos técnicos, componentes do programa e saltos como o triplo axel.",
        "nl": "Begrijp hoe kunstrijders worden beoordeeld. Leer over technische elementen, programmacomponenten en sprongen zoals de drievoudige axel.",
        "ar": "افهم كيف يتم تسجيل المتزلجين الفنيين. تعرف على العناصر التقنية ومكونات البرنامج والقفزات مثل الأكسل الثلاثي.",
        "ja": "フィギュアスケート選手がどのように採点されるか理解しましょう。技術要素、プログラムコンポーネント、トリプルアクセルなどのジャンプについて学びます。",
        "zh": "了解花样滑冰运动员如何评分。学习技术要素、节目内容和三周半跳等跳跃。",
        "ko": "피겨 스케이터들이 어떻게 채점되는지 이해하세요. 기술 요소, 프로그램 구성 요소, 트리플 악셀과 같은 점프에 대해 알아보세요."
    }'::jsonb,

    '{
        "en": "<p><strong>Figure skating</strong> combines athletic jumps, graceful spins, and artistic expression into one of the most watched winter sports. But the scoring system can seem mysterious to newcomers. Let''s break it down.</p><h2>The Two Scores</h2><p>Each skater receives two scores that are added together:</p><h3>Technical Element Score (TES)</h3><p>Points for specific moves: jumps, spins, step sequences, and (in pairs/ice dance) lifts and throws.</p><h3>Program Component Score (PCS)</h3><p>Points for artistry: skating skills, transitions, performance, composition, and interpretation of music.</p><h2>Jump Types (Easiest to Hardest)</h2><ol><li><strong>Toe Loop</strong>: Take off from back outside edge, assisted by toe pick</li><li><strong>Salchow</strong>: Take off from back inside edge</li><li><strong>Loop</strong>: Take off from back outside edge without toe assist</li><li><strong>Flip</strong>: Take off from back inside edge with toe pick</li><li><strong>Lutz</strong>: Take off from back outside edge with toe pick (opposite edge from flip)</li><li><strong>Axel</strong>: The only forward-facing takeoff - adds half rotation (triple axel = 3.5 rotations)</li></ol><h3>Rotation Values</h3><ul><li><strong>Single</strong>: 1 rotation</li><li><strong>Double</strong>: 2 rotations</li><li><strong>Triple</strong>: 3 rotations</li><li><strong>Quad</strong>: 4 rotations (the most difficult)</li></ul><h2>How Jumps Are Scored</h2><p>Each jump has a <strong>base value</strong>. Judges then add or subtract based on execution:</p><ul><li><strong>GOE (Grade of Execution)</strong>: -5 to +5 scale</li><li>Clean landing, good height, speed = positive GOE</li><li>Fall, under-rotation, wrong edge = negative GOE or no value</li></ul><h2>Spins and Step Sequences</h2><p>Spins earn points based on position variety, speed, and centering. Step sequences reward footwork complexity and musical interpretation.</p><h2>Deductions</h2><ul><li>Fall: -1 point per fall</li><li>Time violation: -1 point</li><li>Costume malfunction: -1 point</li></ul><h2>Competition Format</h2><h3>Short Program</h3><p>Required elements in a shorter time frame. Sets the starting order for the free skate.</p><h3>Free Skate (Long Program)</h3><p>Longer program with more freedom in element choice. Combined scores determine the winner.</p><h2>Disciplines</h2><ul><li><strong>Men''s Singles</strong></li><li><strong>Women''s Singles</strong></li><li><strong>Pairs</strong>: Throws, lifts, side-by-side jumps</li><li><strong>Ice Dance</strong>: Emphasis on dance, lifts must stay below shoulder height</li></ul><h2>Watch on Neve26</h2><p>Follow figure skating events with our schedule tracker. Get notified for free skate finals and watch the world''s best perform!</p>",

        "de": "<p><strong>Eiskunstlauf</strong> kombiniert athletische Sprünge, anmutige Pirouetten und künstlerischen Ausdruck. Aber das Wertungssystem kann für Neulinge mysteriös erscheinen.</p><h2>Die Zwei Wertungen</h2><h3>Technischer Elementwert (TES)</h3><p>Punkte für spezifische Elemente: Sprünge, Pirouetten, Schrittfolgen, Hebungen.</p><h3>Programmkomponentenwert (PCS)</h3><p>Punkte für Kunstfertigkeit: Skating-Skills, Übergänge, Performance, Komposition, Interpretation.</p><h2>Sprungarten (Einfachste bis Schwierigste)</h2><ol><li><strong>Toeloop</strong>: Absprung von Außenkante rückwärts mit Zackenunterstützung</li><li><strong>Salchow</strong>: Absprung von Innenkante rückwärts</li><li><strong>Loop</strong>: Absprung von Außenkante ohne Zackenunterstützung</li><li><strong>Flip</strong>: Absprung von Innenkante mit Zacke</li><li><strong>Lutz</strong>: Absprung von Außenkante mit Zacke</li><li><strong>Axel</strong>: Einziger Vorwärtsabsprung - zusätzliche halbe Drehung</li></ol><h2>Sprungbewertung</h2><p>Jeder Sprung hat einen <strong>Basiswert</strong>. Richter addieren oder subtrahieren basierend auf der Ausführung (GOE: -5 bis +5).</p>",

        "fr": "<p>Le <strong>patinage artistique</strong> combine sauts athlétiques, pirouettes gracieuses et expression artistique. Mais le système de notation peut sembler mystérieux.</p><h2>Les Deux Notes</h2><h3>Score des Éléments Techniques (TES)</h3><p>Points pour des mouvements spécifiques : sauts, pirouettes, séquences de pas, portés.</p><h3>Score des Composantes du Programme (PCS)</h3><p>Points pour l''art : qualité de glisse, transitions, performance, composition, interprétation.</p><h2>Types de Sauts (Plus Facile au Plus Difficile)</h2><ol><li><strong>Toe Loop</strong>: Décollage de la carre arrière extérieure avec pointe</li><li><strong>Salchow</strong>: Décollage de la carre arrière intérieure</li><li><strong>Loop</strong>: Décollage de la carre extérieure sans pointe</li><li><strong>Flip</strong>: Décollage de la carre intérieure avec pointe</li><li><strong>Lutz</strong>: Décollage de la carre extérieure avec pointe</li><li><strong>Axel</strong>: Seul décollage vers l''avant - demi-rotation supplémentaire</li></ol><h2>Notation des Sauts</h2><p>Chaque saut a une <strong>valeur de base</strong>. Les juges ajoutent ou soustraient selon l''exécution (GOE: -5 à +5).</p>",

        "it": "<p>Il <strong>pattinaggio artistico</strong> combina salti atletici, piroette eleganti ed espressione artistica. Ma il sistema di punteggio può sembrare misterioso.</p><h2>I Due Punteggi</h2><h3>Punteggio Elementi Tecnici (TES)</h3><p>Punti per movimenti specifici: salti, piroette, sequenze di passi, sollevamenti.</p><h3>Punteggio Componenti del Programma (PCS)</h3><p>Punti per l''arte: abilità di pattinaggio, transizioni, performance, composizione, interpretazione.</p><h2>Tipi di Salto (Dal Più Facile al Più Difficile)</h2><ol><li><strong>Toe Loop</strong>: Decollo dal filo esterno posteriore con punta</li><li><strong>Salchow</strong>: Decollo dal filo interno posteriore</li><li><strong>Loop</strong>: Decollo dal filo esterno senza punta</li><li><strong>Flip</strong>: Decollo dal filo interno con punta</li><li><strong>Lutz</strong>: Decollo dal filo esterno con punta</li><li><strong>Axel</strong>: Unico decollo in avanti - mezza rotazione in più</li></ol><h2>Punteggio dei Salti</h2><p>Ogni salto ha un <strong>valore base</strong>. I giudici aggiungono o sottraggono in base all''esecuzione (GOE: -5 a +5).</p>",

        "es": "<p>El <strong>patinaje artístico</strong> combina saltos atléticos, giros elegantes y expresión artística. Pero el sistema de puntuación puede parecer misterioso.</p><h2>Las Dos Puntuaciones</h2><h3>Puntuación de Elementos Técnicos (TES)</h3><p>Puntos por movimientos específicos: saltos, giros, secuencias de pasos, elevaciones.</p><h3>Puntuación de Componentes del Programa (PCS)</h3><p>Puntos por el arte: habilidades de patinaje, transiciones, interpretación, composición, interpretación musical.</p><h2>Tipos de Saltos (Más Fácil a Más Difícil)</h2><ol><li><strong>Toe Loop</strong>: Despegue del filo exterior trasero con puntera</li><li><strong>Salchow</strong>: Despegue del filo interior trasero</li><li><strong>Loop</strong>: Despegue del filo exterior sin puntera</li><li><strong>Flip</strong>: Despegue del filo interior con puntera</li><li><strong>Lutz</strong>: Despegue del filo exterior con puntera</li><li><strong>Axel</strong>: Único despegue hacia adelante - media rotación extra</li></ol><h2>Puntuación de Saltos</h2><p>Cada salto tiene un <strong>valor base</strong>. Los jueces suman o restan según la ejecución (GOE: -5 a +5).</p>",

        "pt": "<p>A <strong>patinação artística</strong> combina saltos atléticos, giros graciosos e expressão artística. Mas o sistema de pontuação pode parecer misterioso.</p><h2>As Duas Pontuações</h2><h3>Pontuação de Elementos Técnicos (TES)</h3><p>Pontos por movimentos específicos: saltos, giros, sequências de passos, elevações.</p><h3>Pontuação dos Componentes do Programa (PCS)</h3><p>Pontos pela arte: habilidades de patinação, transições, performance, composição, interpretação.</p><h2>Tipos de Saltos (Mais Fácil ao Mais Difícil)</h2><ol><li><strong>Toe Loop</strong>: Decolagem da lâmina externa traseira com ponta</li><li><strong>Salchow</strong>: Decolagem da lâmina interna traseira</li><li><strong>Loop</strong>: Decolagem da lâmina externa sem ponta</li><li><strong>Flip</strong>: Decolagem da lâmina interna com ponta</li><li><strong>Lutz</strong>: Decolagem da lâmina externa com ponta</li><li><strong>Axel</strong>: Única decolagem para frente - meia rotação extra</li></ol><h2>Pontuação de Saltos</h2><p>Cada salto tem um <strong>valor base</strong>. Os juízes somam ou subtraem com base na execução (GOE: -5 a +5).</p>",

        "nl": "<p><strong>Kunstrijden</strong> combineert atletische sprongen, sierlijke pirouettes en artistieke expressie. Maar het scoresysteem kan mysterieus lijken.</p><h2>De Twee Scores</h2><h3>Technische Elementen Score (TES)</h3><p>Punten voor specifieke bewegingen: sprongen, pirouettes, stapsequenties, liften.</p><h3>Programmacomponenten Score (PCS)</h3><p>Punten voor artisticiteit: schaatsvaardigheden, overgangen, performance, compositie, interpretatie.</p><h2>Sprongtypes (Makkelijkst naar Moeilijkst)</h2><ol><li><strong>Toe Loop</strong>: Afzet vanaf achter buitenkant met teenhaak</li><li><strong>Salchow</strong>: Afzet vanaf achter binnenkant</li><li><strong>Loop</strong>: Afzet vanaf achter buitenkant zonder teenhaak</li><li><strong>Flip</strong>: Afzet vanaf achter binnenkant met teenhaak</li><li><strong>Lutz</strong>: Afzet vanaf achter buitenkant met teenhaak</li><li><strong>Axel</strong>: Enige voorwaartse afzet - halve rotatie extra</li></ol><h2>Sprongscoring</h2><p>Elke sprong heeft een <strong>basiswaarde</strong>. Juryleden tellen op of af op basis van uitvoering (GOE: -5 tot +5).</p>",

        "ar": "<p>يجمع <strong>التزلج الفني</strong> بين القفزات الرياضية والدورانات الرشيقة والتعبير الفني. لكن نظام التسجيل قد يبدو غامضاً.</p><h2>الدرجتان</h2><h3>درجة العناصر التقنية (TES)</h3><p>نقاط للحركات المحددة: القفزات، الدورانات، تسلسلات الخطوات، الرفعات.</p><h3>درجة مكونات البرنامج (PCS)</h3><p>نقاط للفن: مهارات التزلج، الانتقالات، الأداء، التكوين، التفسير.</p><h2>أنواع القفزات (من الأسهل إلى الأصعب)</h2><ol><li><strong>توي لوب</strong>: انطلاق من الحافة الخارجية الخلفية بمساعدة الأسنان</li><li><strong>سالكو</strong>: انطلاق من الحافة الداخلية الخلفية</li><li><strong>لوب</strong>: انطلاق من الحافة الخارجية بدون أسنان</li><li><strong>فليب</strong>: انطلاق من الحافة الداخلية مع الأسنان</li><li><strong>لوتز</strong>: انطلاق من الحافة الخارجية مع الأسنان</li><li><strong>أكسل</strong>: الانطلاق الأمامي الوحيد - نصف دورة إضافية</li></ol><h2>تسجيل القفزات</h2><p>لكل قفزة <strong>قيمة أساسية</strong>. يضيف الحكام أو يطرحون بناءً على التنفيذ (GOE: -5 إلى +5).</p>",

        "ja": "<p><strong>フィギュアスケート</strong>は、アスレチックなジャンプ、優雅なスピン、芸術的な表現を組み合わせています。しかし、採点システムは初心者には分かりにくいかもしれません。</p><h2>2つのスコア</h2><h3>技術要素点（TES）</h3><p>特定の動きへの得点：ジャンプ、スピン、ステップシークエンス、リフト。</p><h3>プログラムコンポーネントスコア（PCS）</h3><p>芸術性への得点：スケーティングスキル、トランジション、パフォーマンス、構成、音楽の解釈。</p><h2>ジャンプの種類（簡単から難しい順）</h2><ol><li><strong>トウループ</strong>：後ろ外側エッジからトウで踏み切り</li><li><strong>サルコウ</strong>：後ろ内側エッジから踏み切り</li><li><strong>ループ</strong>：後ろ外側エッジからトウなしで踏み切り</li><li><strong>フリップ</strong>：後ろ内側エッジからトウで踏み切り</li><li><strong>ルッツ</strong>：後ろ外側エッジからトウで踏み切り</li><li><strong>アクセル</strong>：唯一の前向き踏み切り - 半回転追加</li></ol><h2>ジャンプの採点</h2><p>各ジャンプには<strong>基礎点</strong>があります。ジャッジは実行に基づいて加減点します（GOE：-5〜+5）。</p>",

        "zh": "<p><strong>花样滑冰</strong>结合了运动跳跃、优雅旋转和艺术表达。但评分系统对新手来说可能显得神秘。</p><h2>两个分数</h2><h3>技术要素分（TES）</h3><p>特定动作的分数：跳跃、旋转、步法序列、托举。</p><h3>节目内容分（PCS）</h3><p>艺术性分数：滑行技术、过渡、表演、编排、音乐诠释。</p><h2>跳跃类型（从易到难）</h2><ol><li><strong>后外点冰跳</strong>：从后外刃用冰刀齿起跳</li><li><strong>后内结环跳</strong>：从后内刃起跳</li><li><strong>后外结环跳</strong>：从后外刃不用齿起跳</li><li><strong>后内点冰跳</strong>：从后内刃用齿起跳</li><li><strong>勾手跳</strong>：从后外刃用齿起跳</li><li><strong>阿克塞尔跳</strong>：唯一向前起跳 - 多半周</li></ol><h2>跳跃评分</h2><p>每个跳跃有<strong>基础分值</strong>。裁判根据执行加减分（GOE：-5到+5）。</p>",

        "ko": "<p><strong>피겨 스케이팅</strong>은 운동적인 점프, 우아한 스핀, 예술적 표현을 결합합니다. 하지만 채점 시스템은 초보자에게 신비롭게 보일 수 있습니다.</p><h2>두 가지 점수</h2><h3>기술 요소 점수 (TES)</h3><p>특정 동작에 대한 점수: 점프, 스핀, 스텝 시퀀스, 리프트.</p><h3>프로그램 구성 요소 점수 (PCS)</h3><p>예술성 점수: 스케이팅 기술, 트랜지션, 퍼포먼스, 구성, 음악 해석.</p><h2>점프 유형 (쉬운 것부터 어려운 것까지)</h2><ol><li><strong>토 루프</strong>: 뒤쪽 바깥 에지에서 토로 도약</li><li><strong>살코</strong>: 뒤쪽 안쪽 에지에서 도약</li><li><strong>루프</strong>: 뒤쪽 바깥 에지에서 토 없이 도약</li><li><strong>플립</strong>: 뒤쪽 안쪽 에지에서 토로 도약</li><li><strong>루츠</strong>: 뒤쪽 바깥 에지에서 토로 도약</li><li><strong>악셀</strong>: 유일한 앞으로 도약 - 반 회전 추가</li></ol><h2>점프 채점</h2><p>각 점프에는 <strong>기본 점수</strong>가 있습니다. 심판은 실행에 따라 가감합니다 (GOE: -5에서 +5).</p>"
    }'::jsonb,

    'sport-explainer',
    'FS',

    '{
        "en": "Complete guide to figure skating scoring. Learn about TES, PCS, jump types from toe loop to axel, GOE, and how judges score performances.",
        "de": "Kompletter Leitfaden zur Eiskunstlauf-Wertung. TES, PCS, Sprungarten vom Toeloop bis Axel, GOE und wie Richter bewerten.",
        "fr": "Guide complet de la notation du patinage artistique. TES, PCS, types de sauts du toe loop à l''axel, GOE et notation des juges.",
        "it": "Guida completa al punteggio del pattinaggio artistico. TES, PCS, tipi di salto dal toe loop all''axel, GOE e valutazione dei giudici.",
        "es": "Guía completa de puntuación del patinaje artístico. TES, PCS, tipos de saltos del toe loop al axel, GOE y cómo puntúan los jueces.",
        "pt": "Guia completo de pontuação da patinação artística. TES, PCS, tipos de saltos do toe loop ao axel, GOE e como os juízes pontuam.",
        "nl": "Complete gids voor kunstrijden scoring. TES, PCS, sprongtypes van toe loop tot axel, GOE en hoe juryleden scoren.",
        "ar": "دليل شامل لتسجيل التزلج الفني. TES، PCS، أنواع القفزات من توي لوب إلى أكسل، GOE وكيف يسجل الحكام.",
        "ja": "フィギュアスケート採点完全ガイド。TES、PCS、トウループからアクセルまでのジャンプ種類、GOE、ジャッジの採点方法。",
        "zh": "花样滑冰评分完全指南。TES、PCS、从后外点冰跳到阿克塞尔的跳跃类型、GOE以及裁判如何评分。",
        "ko": "피겨 스케이팅 채점 완벽 가이드. TES, PCS, 토 루프부터 악셀까지의 점프 유형, GOE, 심판 채점 방법."
    }'::jsonb,

    'published',
    NOW(),
    'manual'
);

-- ============================================================================
-- 7. Speed Skating: Short Track vs Long Track
-- ============================================================================
INSERT INTO articles (
    slug, title, excerpt, content, category, sport_code,
    meta_description, status, published_at, source_type
) VALUES (
    'speed-skating-short-track-vs-long-track',

    '{
        "en": "Speed Skating: Short Track vs Long Track",
        "de": "Eisschnelllauf: Short Track vs Long Track",
        "fr": "Patinage de Vitesse : Piste Courte vs Longue Piste",
        "it": "Pattinaggio di Velocità: Short Track vs Long Track",
        "es": "Patinaje de Velocidad: Pista Corta vs Pista Larga",
        "pt": "Patinação de Velocidade: Pista Curta vs Pista Longa",
        "nl": "Schaatsen: Shorttrack vs Langebaan",
        "ar": "التزلج السريع: المضمار القصير مقابل المضمار الطويل",
        "ja": "スピードスケート：ショートトラック vs ロングトラック",
        "zh": "速度滑冰：短道 vs 长道",
        "ko": "스피드 스케이팅: 쇼트트랙 vs 롱트랙"
    }'::jsonb,

    '{
        "en": "Discover the differences between short track and long track speed skating. From track sizes and race formats to world records and top athletes in both disciplines.",
        "de": "Entdecken Sie die Unterschiede zwischen Short Track und Long Track Eisschnelllauf. Bahngrößen, Rennformate, Weltrekorde und Top-Athleten.",
        "fr": "Découvrez les différences entre le patinage de vitesse en piste courte et longue. Tailles de piste, formats de course et meilleurs athlètes.",
        "it": "Scopri le differenze tra short track e long track nel pattinaggio di velocità. Dimensioni della pista, formati di gara e migliori atleti.",
        "es": "Descubre las diferencias entre patinaje de velocidad en pista corta y larga. Tamaños de pista, formatos de carrera y mejores atletas.",
        "pt": "Descubra as diferenças entre patinação de velocidade em pista curta e longa. Tamanhos de pista, formatos de corrida e melhores atletas.",
        "nl": "Ontdek de verschillen tussen shorttrack en langebaan schaatsen. Baangroottes, raceformaten en topathleten.",
        "ar": "اكتشف الفروق بين التزلج السريع على المضمار القصير والطويل. أحجام المضمار وأشكال السباق وأفضل الرياضيين.",
        "ja": "ショートトラックとロングトラックスピードスケートの違いを発見。トラックサイズ、レース形式、トップ選手を解説。",
        "zh": "了解短道速滑和长道速滑的区别。赛道大小、比赛形式和顶级运动员。",
        "ko": "쇼트트랙과 롱트랙 스피드 스케이팅의 차이점을 알아보세요. 트랙 크기, 경기 형식, 최고의 선수들."
    }'::jsonb,

    '{
        "en": "<p><strong>Speed skating</strong> comes in two distinct flavors, each with its own excitement and strategy. Let''s explore what makes each discipline unique.</p><h2>Long Track Speed Skating</h2><h3>The Basics</h3><p>Athletes race in pairs around a 400-meter oval track, skating counter-clockwise. One skater starts on the inner lane, one on the outer, and they switch lanes each lap to ensure fairness.</p><h3>Distances</h3><ul><li><strong>Sprint</strong>: 500m, 1000m</li><li><strong>Middle Distance</strong>: 1500m</li><li><strong>Long Distance</strong>: 3000m (women), 5000m, 10000m (men)</li><li><strong>Team Pursuit</strong>: 3 skaters per team, 8 laps</li><li><strong>Mass Start</strong>: All skaters start together</li></ul><h3>Racing Against the Clock</h3><p>In most events, skaters race against the clock rather than each other directly. The fastest time wins, regardless of which pair skated it.</p><h3>Top Athletes</h3><p>Sweden''s <a href=\"/nils-van-der-poel-profile/\">Nils van der Poel</a> set stunning world records before stepping back from competition. The Netherlands'' <a href=\"/jutta-leerdam-profile/\">Jutta Leerdam</a> dominates women''s sprints with incredible power.</p><h2>Short Track Speed Skating</h2><h3>The Basics</h3><p>Multiple skaters race simultaneously on a 111.12-meter track (inside a hockey rink). Contact, passing, and strategy make it chaotic and exciting.</p><h3>Distances</h3><ul><li><strong>Individual</strong>: 500m, 1000m, 1500m</li><li><strong>Relay</strong>: 3000m (women), 5000m (men)</li></ul><h3>Head-to-Head Racing</h3><p>Skaters race in heats, with the top finishers advancing to semifinals and finals. Position matters - first across the line advances, regardless of time.</p><h3>Tactics and Contact</h3><p>Drafting, late passes, and strategic positioning are crucial. Falls and disqualifications are common - it''s a high-risk, high-reward sport.</p><h2>Equipment Differences</h2><table><tr><th>Feature</th><th>Long Track</th><th>Short Track</th></tr><tr><td>Blade Length</td><td>40-50cm</td><td>30-45cm</td></tr><tr><td>Blade Attachment</td><td>Clap skates (hinged)</td><td>Fixed mount</td></tr><tr><td>Protection</td><td>Minimal</td><td>Helmet, cut-proof gear</td></tr></table><h2>World Records</h2><p>Long track records are set at high-altitude rinks (like Salt Lake City) where thinner air reduces resistance. Short track records depend more on race dynamics.</p><h2>Watch on Neve26</h2><p>Follow both speed skating disciplines with our schedule tracker. Get notifications for world record attempts and photo finishes!</p>",

        "de": "<p><strong>Eisschnelllauf</strong> gibt es in zwei verschiedenen Varianten. Lassen Sie uns erkunden, was jede Disziplin einzigartig macht.</p><h2>Long Track Eisschnelllauf</h2><h3>Die Grundlagen</h3><p>Athleten laufen paarweise um eine 400-Meter-Ovalbahn gegen den Uhrzeigersinn. Sie wechseln jede Runde die Bahn für Fairness.</p><h3>Distanzen</h3><ul><li><strong>Sprint</strong>: 500m, 1000m</li><li><strong>Mitteldistanz</strong>: 1500m</li><li><strong>Langdistanz</strong>: 3000m, 5000m, 10000m</li><li><strong>Teamverfolgung</strong>: 3 Läufer pro Team, 8 Runden</li></ul><h3>Top-Athleten</h3><p>Schwedens <a href=\"/nils-van-der-poel-profile/\">Nils van der Poel</a> stellte atemberaubende Weltrekorde auf. Die Niederländerin <a href=\"/jutta-leerdam-profile/\">Jutta Leerdam</a> dominiert die Damen-Sprints.</p><h2>Short Track Eisschnelllauf</h2><h3>Die Grundlagen</h3><p>Mehrere Läufer fahren gleichzeitig auf einer 111,12-Meter-Bahn. Kontakt und Strategie machen es chaotisch und aufregend.</p><h3>Distanzen</h3><ul><li><strong>Einzel</strong>: 500m, 1000m, 1500m</li><li><strong>Staffel</strong>: 3000m, 5000m</li></ul>",

        "fr": "<p>Le <strong>patinage de vitesse</strong> existe en deux variantes distinctes. Explorons ce qui rend chaque discipline unique.</p><h2>Patinage de Vitesse sur Longue Piste</h2><h3>Les Bases</h3><p>Les athlètes courent en paires autour d''une piste ovale de 400 mètres, patinant dans le sens antihoraire. Ils changent de couloir à chaque tour pour l''équité.</p><h3>Distances</h3><ul><li><strong>Sprint</strong>: 500m, 1000m</li><li><strong>Moyenne Distance</strong>: 1500m</li><li><strong>Longue Distance</strong>: 3000m, 5000m, 10000m</li><li><strong>Poursuite par Équipes</strong>: 3 patineurs par équipe, 8 tours</li></ul><h3>Top Athlètes</h3><p>Le Suédois <a href=\"/nils-van-der-poel-profile/\">Nils van der Poel</a> a établi des records du monde stupéfiants. La Néerlandaise <a href=\"/jutta-leerdam-profile/\">Jutta Leerdam</a> domine les sprints féminins.</p><h2>Patinage de Vitesse sur Piste Courte</h2><h3>Les Bases</h3><p>Plusieurs patineurs courent simultanément sur une piste de 111,12 mètres. Contact et stratégie le rendent chaotique et excitant.</p>",

        "it": "<p>Il <strong>pattinaggio di velocità</strong> esiste in due varianti distinte. Esploriamo cosa rende unica ogni disciplina.</p><h2>Pattinaggio di Velocità su Long Track</h2><h3>Le Basi</h3><p>Gli atleti gareggiano in coppia attorno a una pista ovale di 400 metri, pattinando in senso antiorario. Cambiano corsia ogni giro per equità.</p><h3>Distanze</h3><ul><li><strong>Sprint</strong>: 500m, 1000m</li><li><strong>Media Distanza</strong>: 1500m</li><li><strong>Lunga Distanza</strong>: 3000m, 5000m, 10000m</li><li><strong>Inseguimento a Squadre</strong>: 3 pattinatori per squadra, 8 giri</li></ul><h3>Top Atleti</h3><p>Lo svedese <a href=\"/nils-van-der-poel-profile/\">Nils van der Poel</a> ha stabilito record mondiali stupefacenti. L''olandese <a href=\"/jutta-leerdam-profile/\">Jutta Leerdam</a> domina gli sprint femminili.</p><h2>Pattinaggio di Velocità su Short Track</h2><h3>Le Basi</h3><p>Più pattinatori gareggiano simultaneamente su una pista di 111,12 metri. Contatto e strategia lo rendono caotico ed emozionante.</p>",

        "es": "<p>El <strong>patinaje de velocidad</strong> tiene dos variantes distintas. Exploremos qué hace única cada disciplina.</p><h2>Patinaje de Velocidad en Pista Larga</h2><h3>Lo Básico</h3><p>Los atletas compiten en parejas alrededor de una pista oval de 400 metros, patinando en sentido antihorario. Cambian de carril cada vuelta para equidad.</p><h3>Distancias</h3><ul><li><strong>Sprint</strong>: 500m, 1000m</li><li><strong>Media Distancia</strong>: 1500m</li><li><strong>Larga Distancia</strong>: 3000m, 5000m, 10000m</li><li><strong>Persecución por Equipos</strong>: 3 patinadores por equipo, 8 vueltas</li></ul><h3>Top Atletas</h3><p>El sueco <a href=\"/nils-van-der-poel-profile/\">Nils van der Poel</a> estableció récords mundiales impresionantes. La holandesa <a href=\"/jutta-leerdam-profile/\">Jutta Leerdam</a> domina los sprints femeninos.</p><h2>Patinaje de Velocidad en Pista Corta</h2><h3>Lo Básico</h3><p>Varios patinadores compiten simultáneamente en una pista de 111,12 metros. El contacto y la estrategia lo hacen caótico y emocionante.</p>",

        "pt": "<p>A <strong>patinação de velocidade</strong> tem duas variantes distintas. Vamos explorar o que torna cada disciplina única.</p><h2>Patinação de Velocidade em Pista Longa</h2><h3>O Básico</h3><p>Os atletas competem em pares ao redor de uma pista oval de 400 metros, patinando no sentido anti-horário. Eles trocam de pista a cada volta para equidade.</p><h3>Distâncias</h3><ul><li><strong>Sprint</strong>: 500m, 1000m</li><li><strong>Média Distância</strong>: 1500m</li><li><strong>Longa Distância</strong>: 3000m, 5000m, 10000m</li><li><strong>Perseguição por Equipes</strong>: 3 patinadores por equipe, 8 voltas</li></ul><h3>Top Atletas</h3><p>O sueco <a href=\"/nils-van-der-poel-profile/\">Nils van der Poel</a> estabeleceu recordes mundiais impressionantes. A holandesa <a href=\"/jutta-leerdam-profile/\">Jutta Leerdam</a> domina os sprints femininos.</p><h2>Patinação de Velocidade em Pista Curta</h2><h3>O Básico</h3><p>Vários patinadores competem simultaneamente em uma pista de 111,12 metros. O contato e a estratégia o tornam caótico e emocionante.</p>",

        "nl": "<p><strong>Schaatsen</strong> kent twee verschillende varianten. Laten we verkennen wat elke discipline uniek maakt.</p><h2>Langebaan Schaatsen</h2><h3>De Basis</h3><p>Atleten rijden in paren rond een 400 meter ovale baan, tegen de klok in. Ze wisselen elke ronde van baan voor eerlijkheid.</p><h3>Afstanden</h3><ul><li><strong>Sprint</strong>: 500m, 1000m</li><li><strong>Middenafstand</strong>: 1500m</li><li><strong>Langeafstand</strong>: 3000m, 5000m, 10000m</li><li><strong>Ploegenachtervolging</strong>: 3 rijders per team, 8 ronden</li></ul><h3>Topathleten</h3><p>De Zweed <a href=\"/nils-van-der-poel-profile/\">Nils van der Poel</a> vestigde verbluffende wereldrecords. De Nederlandse <a href=\"/jutta-leerdam-profile/\">Jutta Leerdam</a> domineert de damessprints.</p><h2>Shorttrack Schaatsen</h2><h3>De Basis</h3><p>Meerdere schaatsers rijden tegelijk op een 111,12 meter baan. Contact en strategie maken het chaotisch en spannend.</p>",

        "ar": "<p>يأتي <strong>التزلج السريع</strong> بنكهتين مختلفتين. دعونا نستكشف ما يجعل كل تخصص فريداً.</p><h2>التزلج السريع على المضمار الطويل</h2><h3>الأساسيات</h3><p>يتسابق الرياضيون في أزواج حول مضمار بيضاوي بطول 400 متر، يتزلجون عكس اتجاه عقارب الساعة. يتبادلون المسارات كل لفة للإنصاف.</p><h3>المسافات</h3><ul><li><strong>سباق السرعة</strong>: 500م، 1000م</li><li><strong>المسافة المتوسطة</strong>: 1500م</li><li><strong>المسافة الطويلة</strong>: 3000م، 5000م، 10000م</li></ul><h3>أفضل الرياضيين</h3><p>سجل السويدي <a href=\"/nils-van-der-poel-profile/\">نيلس فان دير بويل</a> أرقاماً قياسية عالمية مذهلة. تهيمن الهولندية <a href=\"/jutta-leerdam-profile/\">يوتا ليردام</a> على سباقات سرعة السيدات.</p><h2>التزلج السريع على المضمار القصير</h2><h3>الأساسيات</h3><p>يتسابق عدة متزلجين في وقت واحد على مضمار بطول 111.12 متر. التلامس والاستراتيجية يجعلانه فوضوياً ومثيراً.</p>",

        "ja": "<p><strong>スピードスケート</strong>には2つの異なる種類があります。各種目の特徴を探ってみましょう。</p><h2>ロングトラックスピードスケート</h2><h3>基本</h3><p>選手は400メートルの楕円形トラックをペアで反時計回りに滑ります。公平性のために毎周レーンを交換します。</p><h3>距離</h3><ul><li><strong>スプリント</strong>：500m、1000m</li><li><strong>中距離</strong>：1500m</li><li><strong>長距離</strong>：3000m、5000m、10000m</li><li><strong>チームパシュート</strong>：1チーム3人、8周</li></ul><h3>トップ選手</h3><p>スウェーデンの<a href=\"/nils-van-der-poel-profile/\">ニルス・ファンデルプール</a>が驚異的な世界記録を樹立しました。オランダの<a href=\"/jutta-leerdam-profile/\">ユッタ・レールダム</a>が女子スプリントを支配しています。</p><h2>ショートトラックスピードスケート</h2><h3>基本</h3><p>複数の選手が111.12メートルのトラックで同時にレースします。接触と戦略が混沌とした興奮を生み出します。</p>",

        "zh": "<p><strong>速度滑冰</strong>有两种不同的形式。让我们探索每种项目的独特之处。</p><h2>长道速滑</h2><h3>基础知识</h3><p>运动员成对在400米椭圆形赛道上逆时针滑行。每圈交换赛道以确保公平。</p><h3>距离</h3><ul><li><strong>短距离</strong>：500米、1000米</li><li><strong>中距离</strong>：1500米</li><li><strong>长距离</strong>：3000米、5000米、10000米</li><li><strong>团体追逐</strong>：每队3人，8圈</li></ul><h3>顶级运动员</h3><p>瑞典的<a href=\"/nils-van-der-poel-profile/\">尼尔斯·范德波尔</a>创造了惊人的世界纪录。荷兰的<a href=\"/jutta-leerdam-profile/\">尤塔·莱尔达姆</a>统治着女子短距离。</p><h2>短道速滑</h2><h3>基础知识</h3><p>多名运动员在111.12米的赛道上同时比赛。接触和策略使其充满混乱和刺激。</p>",

        "ko": "<p><strong>스피드 스케이팅</strong>에는 두 가지 다른 종류가 있습니다. 각 종목의 특징을 살펴봅시다.</p><h2>롱트랙 스피드 스케이팅</h2><h3>기본</h3><p>선수들은 400미터 타원형 트랙을 쌍으로 반시계 방향으로 스케이팅합니다. 공정성을 위해 매 바퀴마다 레인을 교환합니다.</p><h3>거리</h3><ul><li><strong>스프린트</strong>: 500m, 1000m</li><li><strong>중거리</strong>: 1500m</li><li><strong>장거리</strong>: 3000m, 5000m, 10000m</li><li><strong>팀 추월</strong>: 팀당 3명, 8바퀴</li></ul><h3>최고의 선수</h3><p>스웨덴의 <a href=\"/nils-van-der-poel-profile/\">닐스 판 데르 푈</a>이 놀라운 세계 기록을 세웠습니다. 네덜란드의 <a href=\"/jutta-leerdam-profile/\">유타 레르담</a>이 여자 스프린트를 지배하고 있습니다.</p><h2>쇼트트랙 스피드 스케이팅</h2><h3>기본</h3><p>여러 선수가 111.12미터 트랙에서 동시에 경쟁합니다. 접촉과 전략이 혼란스럽고 흥미진진하게 만듭니다.</p>"
    }'::jsonb,

    'sport-explainer',
    'SS',

    '{
        "en": "Complete guide to speed skating. Learn the differences between short track and long track, distances, world records, and top athletes in both disciplines.",
        "de": "Kompletter Leitfaden zum Eisschnelllauf. Unterschiede zwischen Short Track und Long Track, Distanzen, Weltrekorde und Top-Athleten.",
        "fr": "Guide complet du patinage de vitesse. Différences entre piste courte et longue, distances, records du monde et meilleurs athlètes.",
        "it": "Guida completa al pattinaggio di velocità. Differenze tra short track e long track, distanze, record mondiali e migliori atleti.",
        "es": "Guía completa del patinaje de velocidad. Diferencias entre pista corta y larga, distancias, récords mundiales y mejores atletas.",
        "pt": "Guia completo de patinação de velocidade. Diferenças entre pista curta e longa, distâncias, recordes mundiais e melhores atletas.",
        "nl": "Complete gids voor schaatsen. Verschillen tussen shorttrack en langebaan, afstanden, wereldrecords en topathleten.",
        "ar": "دليل شامل للتزلج السريع. الفروق بين المضمار القصير والطويل، المسافات، الأرقام القياسية العالمية وأفضل الرياضيين.",
        "ja": "スピードスケート完全ガイド。ショートトラックとロングトラックの違い、距離、世界記録、トップ選手を解説。",
        "zh": "速度滑冰完全指南。了解短道和长道的区别、距离、世界纪录和顶级运动员。",
        "ko": "스피드 스케이팅 완벽 가이드. 쇼트트랙과 롱트랙의 차이점, 거리, 세계 기록, 최고의 선수들."
    }'::jsonb,

    'published',
    NOW(),
    'manual'
);

-- ============================================================================
-- 8. Luge Explained: The Fastest Sport on Ice
-- ============================================================================
INSERT INTO articles (
    slug, title, excerpt, content, category, sport_code,
    meta_description, status, published_at, source_type
) VALUES (
    'luge-explained-fastest-sport-ice',

    '{
        "en": "Luge Explained: The Fastest Sport on Ice",
        "de": "Rodeln erklärt: Der schnellste Sport auf Eis",
        "fr": "La Luge Expliquée : Le Sport le Plus Rapide sur Glace",
        "it": "Slittino Spiegato: Lo Sport Più Veloce sul Ghiaccio",
        "es": "Luge Explicado: El Deporte Más Rápido sobre Hielo",
        "pt": "Luge Explicado: O Esporte Mais Rápido no Gelo",
        "nl": "Rodelen Uitgelegd: De Snelste Sport op Ijs",
        "ar": "الزحليقة موضحة: أسرع رياضة على الجليد",
        "ja": "リュージュ解説：氷上最速のスポーツ",
        "zh": "雪橇解析：冰上最快的运动",
        "ko": "루지 설명: 얼음 위의 가장 빠른 스포츠"
    }'::jsonb,

    '{
        "en": "Learn how luge works and why it''s the fastest sliding sport. Understand the differences between luge, skeleton, and bobsled, and meet the athletes who race at 150 km/h.",
        "de": "Erfahren Sie, wie Rodeln funktioniert und warum es der schnellste Rutschsport ist. Verstehen Sie die Unterschiede zwischen Rodeln, Skeleton und Bob.",
        "fr": "Apprenez comment fonctionne la luge et pourquoi c''est le sport de glisse le plus rapide. Comprenez les différences entre luge, skeleton et bobsleigh.",
        "it": "Scopri come funziona lo slittino e perché è lo sport di scivolamento più veloce. Comprendi le differenze tra slittino, skeleton e bob.",
        "es": "Aprende cómo funciona el luge y por qué es el deporte de deslizamiento más rápido. Entiende las diferencias entre luge, skeleton y bobsled.",
        "pt": "Aprenda como funciona o luge e por que é o esporte de deslizamento mais rápido. Entenda as diferenças entre luge, skeleton e bobsled.",
        "nl": "Leer hoe rodelen werkt en waarom het de snelste glijsport is. Begrijp de verschillen tussen rodelen, skeleton en bobsleeën.",
        "ar": "تعلم كيف تعمل الزحليقة ولماذا هي أسرع رياضة انزلاق. افهم الفروق بين الزحليقة والسكيلتون والبوبسليد.",
        "ja": "リュージュの仕組みとなぜ最速の滑走スポーツなのかを学びましょう。リュージュ、スケルトン、ボブスレーの違いを理解しましょう。",
        "zh": "了解雪橇的运作方式以及为什么它是最快的滑行运动。理解雪橇、钢架雪车和雪车的区别。",
        "ko": "루지의 작동 방식과 왜 가장 빠른 슬라이딩 스포츠인지 알아보세요. 루지, 스켈레톤, 봅슬레이의 차이점을 이해하세요."
    }'::jsonb,

    '{
        "en": "<p><strong>Luge</strong> is the fastest of the sliding sports. Athletes lie face-up on small sleds, racing down icy tracks at speeds exceeding 150 km/h - with only their bodies for brakes.</p><h2>How Luge Works</h2><p>Athletes start by sitting at the top of the track, gripping handles on either side. They rock back and forth to build momentum, then push off and lie back.</p><p>Once moving, they steer using:</p><ul><li><strong>Shoulder pressure</strong> on the sled</li><li><strong>Leg pressure</strong> through their calves on the runners</li><li><strong>Subtle weight shifts</strong></li></ul><p>The goal is to find the perfect line through each curve - too high wastes time, too low risks crashing.</p><h2>Luge vs Skeleton vs Bobsled</h2><table><tr><th>Sport</th><th>Position</th><th>Direction</th><th>Team Size</th></tr><tr><td>Luge</td><td>Lying back, face-up</td><td>Feet-first</td><td>1 or 2</td></tr><tr><td>Skeleton</td><td>Lying prone, face-down</td><td>Head-first</td><td>1</td></tr><tr><td>Bobsled</td><td>Sitting in enclosed sled</td><td>Feet-first</td><td>2 or 4</td></tr></table><p>Luge is fastest because the feet-first position allows athletes to lie flat, reducing air resistance.</p><h2>Events</h2><ul><li><strong>Men''s Singles</strong>: 4 runs, combined time</li><li><strong>Women''s Singles</strong>: 4 runs, combined time</li><li><strong>Doubles</strong>: 2 runs, one athlete lies on top of the other</li><li><strong>Team Relay</strong>: 1 run each by women''s, men''s, and doubles teams</li></ul><h2>The Track</h2><p>Luge tracks are between 1,000-1,500 meters long with multiple curves. Some famous tracks:</p><ul><li><a href=\"/lake-placid-venue-guide/\">Lake Placid</a>, USA - Site of historic competitions</li><li>Whistler, Canada - One of the fastest tracks</li><li>Sigulda, Latvia - Eastern European powerhouse venue</li></ul><h2>Safety</h2><p>Modern luge is safer than ever, with:</p><ul><li>Padded walls on dangerous curves</li><li>Aerodynamic helmets</li><li>Speed limits on some tracks</li></ul><p>But it remains extreme - athletes experience forces up to 5G in the curves.</p><h2>Start Technique</h2><p>The start is crucial. Athletes wear gloves with small spikes to grip the ice during their powerful paddle strokes. A hundredth of a second at the start can mean several hundredths at the finish.</p><h2>Watch on Neve26</h2><p>Follow luge, skeleton, and <a href=\"/bobsled-explained/\">bobsled</a> events with our schedule tracker. Get notifications for race days and world record attempts!</p>",

        "de": "<p><strong>Rodeln</strong> ist der schnellste der Rutschsportarten. Athleten liegen mit dem Gesicht nach oben auf kleinen Schlitten und rasen mit über 150 km/h die Eisbahn hinunter.</p><h2>Wie Rodeln funktioniert</h2><p>Athleten starten sitzend, greifen Griffe auf beiden Seiten. Sie schaukeln vor und zurück für Schwung, stoßen sich dann ab und legen sich zurück.</p><p>Einmal in Bewegung, steuern sie mit:</p><ul><li><strong>Schulterdruck</strong> auf den Schlitten</li><li><strong>Beindruck</strong> durch die Waden auf die Kufen</li><li><strong>Subtile Gewichtsverlagerungen</strong></li></ul><h2>Rodeln vs Skeleton vs Bob</h2><table><tr><th>Sport</th><th>Position</th><th>Richtung</th><th>Teamgröße</th></tr><tr><td>Rodeln</td><td>Rückenlage, Gesicht oben</td><td>Füße voran</td><td>1 oder 2</td></tr><tr><td>Skeleton</td><td>Bauchlage, Gesicht unten</td><td>Kopf voran</td><td>1</td></tr><tr><td>Bob</td><td>Sitzend im geschlossenen Schlitten</td><td>Füße voran</td><td>2 oder 4</td></tr></table><h2>Disziplinen</h2><ul><li><strong>Herren Einzel</strong>: 4 Läufe, Gesamtzeit</li><li><strong>Damen Einzel</strong>: 4 Läufe, Gesamtzeit</li><li><strong>Doppelsitzer</strong>: 2 Läufe, ein Athlet liegt auf dem anderen</li></ul>",

        "fr": "<p>La <strong>luge</strong> est la plus rapide des sports de glisse. Les athlètes s''allongent face vers le haut sur de petits traîneaux, dévalant des pistes glacées à plus de 150 km/h.</p><h2>Comment Fonctionne la Luge</h2><p>Les athlètes démarrent assis, agrippant des poignées de chaque côté. Ils se balancent d''avant en arrière pour prendre de l''élan, puis poussent et se couchent.</p><p>Une fois en mouvement, ils dirigent avec:</p><ul><li><strong>Pression des épaules</strong> sur le traîneau</li><li><strong>Pression des jambes</strong> à travers les mollets sur les patins</li><li><strong>Transferts de poids subtils</strong></li></ul><h2>Luge vs Skeleton vs Bobsleigh</h2><table><tr><th>Sport</th><th>Position</th><th>Direction</th><th>Équipe</th></tr><tr><td>Luge</td><td>Couché sur le dos, face vers le haut</td><td>Pieds en premier</td><td>1 ou 2</td></tr><tr><td>Skeleton</td><td>Couché sur le ventre, face vers le bas</td><td>Tête en premier</td><td>1</td></tr><tr><td>Bobsleigh</td><td>Assis dans un traîneau fermé</td><td>Pieds en premier</td><td>2 ou 4</td></tr></table><h2>Épreuves</h2><ul><li><strong>Simple Messieurs</strong>: 4 manches, temps combiné</li><li><strong>Simple Dames</strong>: 4 manches, temps combiné</li><li><strong>Double</strong>: 2 manches, un athlète allongé sur l''autre</li></ul>",

        "it": "<p>Lo <strong>slittino</strong> è il più veloce degli sport di scivolamento. Gli atleti si sdraiano a faccia in su su piccole slitte, correndo lungo piste ghiacciate a velocità superiori ai 150 km/h.</p><h2>Come Funziona lo Slittino</h2><p>Gli atleti partono seduti, afferrando maniglie su entrambi i lati. Si dondolano avanti e indietro per prendere slancio, poi spingono e si sdraiano.</p><p>Una volta in movimento, sterzano usando:</p><ul><li><strong>Pressione delle spalle</strong> sulla slitta</li><li><strong>Pressione delle gambe</strong> attraverso i polpacci sui pattini</li><li><strong>Spostamenti di peso sottili</strong></li></ul><h2>Slittino vs Skeleton vs Bob</h2><table><tr><th>Sport</th><th>Posizione</th><th>Direzione</th><th>Squadra</th></tr><tr><td>Slittino</td><td>Sdraiato sulla schiena, faccia in su</td><td>Piedi avanti</td><td>1 o 2</td></tr><tr><td>Skeleton</td><td>Sdraiato prono, faccia in giù</td><td>Testa avanti</td><td>1</td></tr><tr><td>Bob</td><td>Seduto in slitta chiusa</td><td>Piedi avanti</td><td>2 o 4</td></tr></table><h2>Gare</h2><ul><li><strong>Singolo Uomini</strong>: 4 manche, tempo combinato</li><li><strong>Singolo Donne</strong>: 4 manche, tempo combinato</li><li><strong>Doppio</strong>: 2 manche, un atleta sdraiato sull''altro</li></ul>",

        "es": "<p>El <strong>luge</strong> es el más rápido de los deportes de deslizamiento. Los atletas se tumban boca arriba en pequeños trineos, corriendo por pistas heladas a velocidades superiores a 150 km/h.</p><h2>Cómo Funciona el Luge</h2><p>Los atletas empiezan sentados, agarrando asas a ambos lados. Se balancean hacia adelante y atrás para tomar impulso, luego empujan y se tumban.</p><p>Una vez en movimiento, dirigen usando:</p><ul><li><strong>Presión de hombros</strong> en el trineo</li><li><strong>Presión de piernas</strong> a través de las pantorrillas en los patines</li><li><strong>Cambios de peso sutiles</strong></li></ul><h2>Luge vs Skeleton vs Bobsled</h2><table><tr><th>Deporte</th><th>Posición</th><th>Dirección</th><th>Equipo</th></tr><tr><td>Luge</td><td>Tumbado boca arriba</td><td>Pies primero</td><td>1 o 2</td></tr><tr><td>Skeleton</td><td>Tumbado boca abajo</td><td>Cabeza primero</td><td>1</td></tr><tr><td>Bobsled</td><td>Sentado en trineo cerrado</td><td>Pies primero</td><td>2 o 4</td></tr></table><h2>Pruebas</h2><ul><li><strong>Individual Hombres</strong>: 4 carreras, tiempo combinado</li><li><strong>Individual Mujeres</strong>: 4 carreras, tiempo combinado</li><li><strong>Dobles</strong>: 2 carreras, un atleta sobre el otro</li></ul>",

        "pt": "<p>O <strong>luge</strong> é o mais rápido dos esportes de deslizamento. Os atletas deitam-se de costas em pequenos trenós, correndo por pistas de gelo a velocidades superiores a 150 km/h.</p><h2>Como Funciona o Luge</h2><p>Os atletas começam sentados, segurando alças em ambos os lados. Eles balançam para frente e para trás para ganhar impulso, depois empurram e deitam-se.</p><p>Uma vez em movimento, eles dirigem usando:</p><ul><li><strong>Pressão dos ombros</strong> no trenó</li><li><strong>Pressão das pernas</strong> através das panturrilhas nos patins</li><li><strong>Mudanças sutis de peso</strong></li></ul><h2>Luge vs Skeleton vs Bobsled</h2><table><tr><th>Esporte</th><th>Posição</th><th>Direção</th><th>Equipe</th></tr><tr><td>Luge</td><td>Deitado de costas, face para cima</td><td>Pés primeiro</td><td>1 ou 2</td></tr><tr><td>Skeleton</td><td>Deitado de bruços, face para baixo</td><td>Cabeça primeiro</td><td>1</td></tr><tr><td>Bobsled</td><td>Sentado em trenó fechado</td><td>Pés primeiro</td><td>2 ou 4</td></tr></table><h2>Provas</h2><ul><li><strong>Individual Masculino</strong>: 4 descidas, tempo combinado</li><li><strong>Individual Feminino</strong>: 4 descidas, tempo combinado</li><li><strong>Duplas</strong>: 2 descidas, um atleta sobre o outro</li></ul>",

        "nl": "<p><strong>Rodelen</strong> is de snelste van de glijsporten. Atleten liggen op hun rug op kleine sledes, racend over ijzige banen met snelheden boven de 150 km/u.</p><h2>Hoe Rodelen Werkt</h2><p>Atleten starten zittend, grijpend aan handvatten aan beide kanten. Ze schommelen heen en weer voor momentum, duwen dan af en liggen achterover.</p><p>Eenmaal in beweging sturen ze met:</p><ul><li><strong>Schouderdruk</strong> op de slee</li><li><strong>Beendruk</strong> door de kuiten op de glijders</li><li><strong>Subtiele gewichtsverschuivingen</strong></li></ul><h2>Rodelen vs Skeleton vs Bobslee</h2><table><tr><th>Sport</th><th>Positie</th><th>Richting</th><th>Team</th></tr><tr><td>Rodelen</td><td>Op de rug liggend, gezicht omhoog</td><td>Voeten eerst</td><td>1 of 2</td></tr><tr><td>Skeleton</td><td>Op de buik liggend, gezicht omlaag</td><td>Hoofd eerst</td><td>1</td></tr><tr><td>Bobslee</td><td>Zittend in gesloten slee</td><td>Voeten eerst</td><td>2 of 4</td></tr></table><h2>Onderdelen</h2><ul><li><strong>Mannen Enkel</strong>: 4 runs, gecombineerde tijd</li><li><strong>Vrouwen Enkel</strong>: 4 runs, gecombineerde tijd</li><li><strong>Doubles</strong>: 2 runs, één atleet op de ander</li></ul>",

        "ar": "<p><strong>الزحليقة</strong> هي أسرع رياضات الانزلاق. يستلقي الرياضيون ووجوههم للأعلى على زلاجات صغيرة، يتسابقون على مسارات جليدية بسرعات تتجاوز 150 كم/س.</p><h2>كيف تعمل الزحليقة</h2><p>يبدأ الرياضيون جالسين، ممسكين بمقابض على كلا الجانبين. يتأرجحون ذهاباً وإياباً لبناء الزخم، ثم يدفعون ويستلقون.</p><p>بمجرد الحركة، يوجهون باستخدام:</p><ul><li><strong>ضغط الكتف</strong> على الزلاجة</li><li><strong>ضغط الساق</strong> عبر السيقان على العدائين</li><li><strong>تحولات وزن خفيفة</strong></li></ul><h2>الزحليقة مقابل السكيلتون مقابل البوبسليد</h2><table><tr><th>الرياضة</th><th>الوضع</th><th>الاتجاه</th><th>الفريق</th></tr><tr><td>زحليقة</td><td>مستلقٍ على الظهر</td><td>القدمان أولاً</td><td>1 أو 2</td></tr><tr><td>سكيلتون</td><td>مستلقٍ على البطن</td><td>الرأس أولاً</td><td>1</td></tr><tr><td>بوبسليد</td><td>جالس في زلاجة مغلقة</td><td>القدمان أولاً</td><td>2 أو 4</td></tr></table>",

        "ja": "<p><strong>リュージュ</strong>は滑走スポーツの中で最速です。選手は小さなそりに仰向けで寝そべり、時速150km以上で氷のコースを駆け下ります。</p><h2>リュージュの仕組み</h2><p>選手は座った状態でスタートし、両側のハンドルを握ります。前後に揺れて勢いをつけ、押し出して後ろに倒れます。</p><p>動き出したら、以下で操縦します：</p><ul><li><strong>肩の圧力</strong>でそりに</li><li><strong>脚の圧力</strong>でふくらはぎを通してランナーに</li><li><strong>微妙な体重移動</strong></li></ul><h2>リュージュ vs スケルトン vs ボブスレー</h2><table><tr><th>競技</th><th>姿勢</th><th>方向</th><th>チーム</th></tr><tr><td>リュージュ</td><td>仰向け、顔を上に</td><td>足から先に</td><td>1または2人</td></tr><tr><td>スケルトン</td><td>うつ伏せ、顔を下に</td><td>頭から先に</td><td>1人</td></tr><tr><td>ボブスレー</td><td>密閉されたそりに座る</td><td>足から先に</td><td>2または4人</td></tr></table><h2>種目</h2><ul><li><strong>男子シングル</strong>：4本、合計タイム</li><li><strong>女子シングル</strong>：4本、合計タイム</li><li><strong>ダブルス</strong>：2本、1人が上に乗る</li></ul>",

        "zh": "<p><strong>雪橇</strong>是滑行运动中最快的。运动员仰卧在小雪橇上，以超过150公里/小时的速度在冰道上疾驰。</p><h2>雪橇的运作方式</h2><p>运动员从坐着开始，握住两侧的把手。他们前后摇摆以建立动力，然后推开并躺下。</p><p>一旦开始移动，他们通过以下方式操控：</p><ul><li><strong>肩部压力</strong>作用于雪橇</li><li><strong>腿部压力</strong>通过小腿作用于滑板</li><li><strong>微妙的重心转移</strong></li></ul><h2>雪橇 vs 钢架雪车 vs 雪车</h2><table><tr><th>运动</th><th>姿势</th><th>方向</th><th>队伍</th></tr><tr><td>雪橇</td><td>仰卧，面朝上</td><td>脚先</td><td>1或2人</td></tr><tr><td>钢架雪车</td><td>俯卧，面朝下</td><td>头先</td><td>1人</td></tr><tr><td>雪车</td><td>坐在封闭雪橇内</td><td>脚先</td><td>2或4人</td></tr></table><h2>项目</h2><ul><li><strong>男子单人</strong>：4轮，综合时间</li><li><strong>女子单人</strong>：4轮，综合时间</li><li><strong>双人</strong>：2轮，一人躺在另一人上面</li></ul>",

        "ko": "<p><strong>루지</strong>는 슬라이딩 스포츠 중 가장 빠릅니다. 선수들은 작은 썰매에 등을 대고 누워 시속 150km 이상의 속도로 얼음 트랙을 내려갑니다.</p><h2>루지의 작동 방식</h2><p>선수들은 앉은 상태에서 시작하여 양쪽 손잡이를 잡습니다. 앞뒤로 흔들어 추진력을 얻은 후 밀고 뒤로 눕습니다.</p><p>움직이기 시작하면 다음을 사용하여 조종합니다:</p><ul><li><strong>어깨 압력</strong>으로 썰매에</li><li><strong>다리 압력</strong>으로 종아리를 통해 러너에</li><li><strong>미묘한 체중 이동</strong></li></ul><h2>루지 vs 스켈레톤 vs 봅슬레이</h2><table><tr><th>스포츠</th><th>자세</th><th>방향</th><th>팀</th></tr><tr><td>루지</td><td>등을 대고 누움, 얼굴 위로</td><td>발부터</td><td>1 또는 2명</td></tr><tr><td>스켈레톤</td><td>엎드려 누움, 얼굴 아래로</td><td>머리부터</td><td>1명</td></tr><tr><td>봅슬레이</td><td>밀폐된 썰매에 앉음</td><td>발부터</td><td>2 또는 4명</td></tr></table><h2>종목</h2><ul><li><strong>남자 싱글</strong>: 4회 주행, 합산 시간</li><li><strong>여자 싱글</strong>: 4회 주행, 합산 시간</li><li><strong>더블</strong>: 2회 주행, 한 선수가 다른 선수 위에 누움</li></ul>"
    }'::jsonb,

    'sport-explainer',
    'LG',

    '{
        "en": "Complete guide to luge. Learn how this fastest sliding sport works, differences vs skeleton and bobsled, and the athletes who race at 150 km/h.",
        "de": "Kompletter Leitfaden zum Rodeln. Wie der schnellste Rutschsport funktioniert, Unterschiede zu Skeleton und Bob, und die Athleten.",
        "fr": "Guide complet de la luge. Comment fonctionne ce sport de glisse le plus rapide, différences avec skeleton et bobsleigh, et les athlètes.",
        "it": "Guida completa allo slittino. Come funziona questo sport di scivolamento più veloce, differenze con skeleton e bob, e gli atleti.",
        "es": "Guía completa del luge. Cómo funciona este deporte de deslizamiento más rápido, diferencias con skeleton y bobsled, y los atletas.",
        "pt": "Guia completo do luge. Como funciona este esporte de deslizamento mais rápido, diferenças com skeleton e bobsled, e os atletas.",
        "nl": "Complete gids voor rodelen. Hoe deze snelste glijsport werkt, verschillen met skeleton en bobslee, en de atleten.",
        "ar": "دليل شامل للزحليقة. كيف تعمل أسرع رياضة انزلاق، الفروق مع السكيلتون والبوبسليد، والرياضيون.",
        "ja": "リュージュ完全ガイド。最速の滑走スポーツの仕組み、スケルトンやボブスレーとの違い、選手について。",
        "zh": "雪橇完全指南。了解这项最快滑行运动的运作方式、与钢架雪车和雪车的区别以及运动员。",
        "ko": "루지 완벽 가이드. 가장 빠른 슬라이딩 스포츠의 작동 방식, 스켈레톤 및 봅슬레이와의 차이점, 선수들."
    }'::jsonb,

    'published',
    NOW(),
    'manual'
);
