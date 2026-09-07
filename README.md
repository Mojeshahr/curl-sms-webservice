<div align="center">

<a href="https://payam-resan.com">
  <img src=".github/assets/logo.svg" width="64" height="64" alt="پیام رسان">
</a>

<h1>نمونه‌کدهای curl وب‌سرویس پیام رسان</h1>

اتصال به وب‌سرویس <a href="https://payam-resan.com"><b>پنل پیامکی پیام رسان</b></a> با curl<br>
یک اسکریپت قابل اجرا به‌ازای هر متد سرویس

[![API](https://img.shields.io/badge/API-V3-0a7cbd)](https://payam-resan.com)
[![curl](https://img.shields.io/badge/curl-7.18%2B-073551)](https://curl.se)
[![jq](https://img.shields.io/badge/jq-1.6%2B-3b7dd8)](https://jqlang.github.io/jq/)
[![License](https://img.shields.io/badge/license-MIT-6e7781)](LICENSE)

<b>فارسی</b> · <a href="README.en.md">English</a>

</div>

<sub>دنبال زبان دیگری هستید؟ همین نمونه‌ها برای زبان‌های دیگر هم در
[github.com/Mojeshahr](https://github.com/Mojeshahr) هست.</sub>

---

## شروع سریع

```bash
git clone https://github.com/Mojeshahr/curl-sms-webservice.git
cd curl-sms-webservice

export PAYAM_RESAN_API_KEY='123456-XXXXXXXXXXXXXXX'
export PAYAM_RESAN_SENDER='30004040'

./examples/v3/account-info.sh
```

با `account-info.sh` شروع کنید: چیزی ارسال نمی‌کند، اعتباری مصرف نمی‌کند، و
اگر جواب داد یعنی کلید و اتصال هر دو سالم‌اند.

## این مخزن پیش از هر زبان دیگری به درد می‌خورد

وقتی ارسال کار نمی‌کند، اولین سؤال این است که مشکل از کد شماست یا از حساب و
شبکه. یک `curl` جواب می‌دهد و بحث را تمام می‌کند. برای همین اینجا مخزن جداگانه
دارد و در همه زبان‌ها یک تب `curl` کنار نمونه هر متد نشسته است.

مخاطب دومش هم کسی است که اصلاً زبان برنامه‌نویسی وسط نیست: یک اسکریپت در cron،
یک هوک در CI، یا یک خط در سرور مانیتورینگ که باید هشدار بفرستد.

## چرا jq یک وابستگی است

قاعده این مخزن‌ها «بدون وابستگی» است و اینجا یک استثنا دارد. شل هیچ پارسر JSON
ندارد. جایگزینش `grep` روی متن پاسخ است که روش غلطی است و کپی‌شدنش بدتر: با یک
فاصله یا ترتیب متفاوت فیلدها بی‌صدا خراب می‌شود.

پس `jq` می‌آید، همان‌طور که مخزن جاوا Gson را گرفت. یک وابستگی، سرشناس، و
نصبش یک دستور است:

```bash
sudo apt install jq       # دبیان و اوبونتو
sudo dnf install jq       # فدورا و RHEL
brew install jq           # مک
```

روی ویندوز اگر `jq` ندارید، مخزن
[powershell-sms-webservice](https://github.com/Mojeshahr/powershell-sms-webservice)
همین کارها را با `Invoke-RestMethod` و بدون هیچ ابزار بیرونی انجام می‌دهد.

## متدها

<div dir="rtl">

| نمونه | متد | کار |
|---|---|---|
| [account-info.sh](examples/v3/account-info.sh) | `AccountInfo` | اعتبار و خطوط فعال |
| [send.sh](examples/v3/send.sh) | `Send` | ارسال ساده با `GET` |
| [send-bulk.sh](examples/v3/send-bulk.sh) | `SendBulk` | یک متن به چند گیرنده، با شناسه پی‌گیری |
| [send-multiple.sh](examples/v3/send-multiple.sh) | `SendMultiple` | متن جدا برای هر گیرنده |
| [token-list.sh](examples/v3/token-list.sh) | `TokenList` | فهرست قالب‌ها |
| [send-token-single.sh](examples/v3/send-token-single.sh) | `SendTokenSingle` | ارسال قالب به یک شماره |
| [send-token-single-get.sh](examples/v3/send-token-single-get.sh) | `SendTokenSingle` | همان، با `GET` |
| [send-token-multi.sh](examples/v3/send-token-multi.sh) | `SendTokenMulti` | یک قالب، چند گیرنده |
| [status-by-id.sh](examples/v3/status-by-id.sh) | `StatusById` | وضعیت با شناسه سامانه |
| [status-by-user-trace-id.sh](examples/v3/status-by-user-trace-id.sh) | `StatusByUserTraceId` | وضعیت با شناسه خودتان |
| [get-inbox.sh](examples/v3/get-inbox.sh) | `GetInbox` | پیامک‌های رسیده |

</div>

## پیش از ارسال واقعی

یک سرور آزمایشی هست که مثل سرور عملیاتی جواب می‌دهد ولی پیامکی نمی‌فرستد و
اعتباری مصرف نمی‌کند. کافی است `V3` در نشانی را با `V3SandBox` عوض کنید. تنها
استثنا `TokenList` است که روی آن سرور پیاده نشده.

## زبان اسکریپت‌ها انگلیسی است

توضیح‌ها و پیام‌های خطای این فایل‌ها انگلیسی‌اند، برخلاف بقیه مخزن‌ها که فارسی
دارند. دلیلش سلیقه نیست: متن فارسی داخل اسکریپت شل در بسیاری از ترمینال‌ها و
از راه `ssh` به‌شکل نامفهوم درمی‌آید و ویرایش فایل را سخت می‌کند.

تنها جایی که فارسی هست، خودِ متن پیامک داخل بدنه JSON است، چون آن داده‌ای است
که واقعاً به سرویس می‌رود.

## چند نکته که وقت‌تان را می‌خرد

**کد وضعیت HTTP را نخوانید.** سرویس همیشه `200` برمی‌گرداند، حتی وقتی کلید
اشتباه است. حتی `curl -f` هم اینجا کمکی نمی‌کند. تصمیم را از فیلد `Success`
بگیرید، همان‌طور که هر نمونه اینجا می‌گیرد.

**سوییچ `--data-urlencode` را با `-d` عوض نکنید.** در `send.sh` این سوییچ متن
را دقیقاً یک بار encode می‌کند. اگر خودتان هم پیش از آن encode کنید، پیامک با
نویسه‌های `%D8` به گوشی می‌رسد.

**شماره گیرنده صفر ابتدایی ندارد.** یعنی `9121112222` یا با کد کشور
`989121112222`. شماره‌ای که با `9` یا `989` شروع نشود کد خطای `13` می‌گیرد.

**برای هر گیرنده یک `UserTraceId` یکتا بفرستید.** بعد از یک timeout، این تنها
راه فهمیدن این است که پیامک ثبت شده یا نه.

## امنیت کلید

کلید یک راز است و در `curl` دو خطر مخصوص خودش دارد.

کلید را در خط فرمان ننویسید. هر چیزی که در آرگومان‌ها بیاید در تاریخچه شل و در
فهرست پراسس‌های سیستم دیده می‌شود، یعنی هر کاربر دیگری روی همان ماشین می‌تواند
بخواندش. نمونه‌ها به همین دلیل از متغیر محیطی می‌خوانند.

و در محیط عملیاتی متد `Send` و واریانت `GET` قالب را کنار بگذارید. آنجا کلید
داخل نشانی می‌نشیند و در لاگ وب‌سرور و هدر `Referer` ثبت می‌شود.

اگر کلیدی لو رفت، از پنل یکی تازه بسازید. کلید حذف‌شده برنمی‌گردد.

## ساختار

<div dir="rtl">

| مسیر | چه چیزی دارد |
|---|---|
| `examples/v3/` | یک اسکریپت مستقل به‌ازای هر عملیات سرویس |
| `.env.example` | نمونه متغیرهای محیطی |

</div>

عدد `v3` در مسیر عمدی است. نسخه تازه سرویس یعنی پوشه `examples/v<n>/` تازه، و
پوشه موجود دست‌نخورده می‌ماند.

## مستندات و پشتیبانی

راهنمای کامل وب‌سرویس در [docs.payam-resan.com](https://docs.payam-resan.com)
است. توصیف ماشین‌خوان OpenAPI هم در
[sms-webservice-spec](https://github.com/Mojeshahr/sms-webservice-spec).

## مجوز

منتشرشده با مجوز MIT. متن کامل در [`LICENSE`](LICENSE).
