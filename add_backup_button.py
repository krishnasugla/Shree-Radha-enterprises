with open('index.html') as f:
    content = f.read()

changes = 0

btn_old = '    <button class="btn ghost sm" id="logoutBtn" style="border-color:#3a4658; color:#c8cfd3;">Log out</button>'
btn_new = '    <button class="btn ghost sm" id="backupBtn" style="border-color:#3a4658; color:#c8cfd3;">Download backup</button>\n    <button class="btn ghost sm" id="logoutBtn" style="border-color:#3a4658; color:#c8cfd3;">Log out</button>'
if btn_old in content and 'backupBtn' not in content:
    content = content.replace(btn_old, btn_new, 1)
    changes += 1

js_old = "$('#logoutBtn').addEventListener('click', async () => {\n  if(!sb) return;\n  await sb.auth.signOut();\n});\n\ncheckAuthAndBoot();"
js_new = "$('#logoutBtn').addEventListener('click', async () => {\n  if(!sb) return;\n  await sb.auth.signOut();\n});\n\n/* ---------------- full backup export (.xlsx) ---------------- */\n$('#backupBtn').addEventListener('click', () => {\n  if(!bills.length){\n    toast('Nothing to back up yet — the ledger is empty.');\n    return;\n  }\n\n  const billRows = [...bills]\n    .sort((a,b) => (a.date||'').localeCompare(b.date||''))\n    .map(b => ({\n      'Company': b.company, 'Date': b.date, 'Vch/Bill No': b.billNo, 'Retailer': b.retailer,\n      'Total Amount': toNum(b.totalAmount),\n      'Delivery Date': b.deliveryDate, 'Area': b.area, 'Sales Person': b.salesPerson,\n      'Delivery Partner': b.deliveryPartner, 'Delivery Status': b.deliveryStatus,\n      'Amount Collected': b.amountAtDelivery === '' ? '' : toNum(b.amountAtDelivery),\n      'Discount': b.discount === '' ? '' : toNum(b.discount),\n      'Comments': b.comments, 'Next Visit Planned': b.nextVisitPlanned,\n      'Total Collected': totalCollected(b), 'Balance Outstanding': balanceOutstanding(b),\n      'Settlement Status': settlementStatus(b)\n    }));\n\n  const visitRows = [];\n  [...bills].sort((a,b) => (a.date||'').localeCompare(b.date||'')).forEach(b => {\n    (b.visits||[]).forEach(v => {\n      visitRows.push({\n        'Company': b.company, 'Vch/Bill No': b.billNo, 'Retailer': b.retailer,\n        'Visit Date': v.date, 'Assigned To': v.assignedTo, 'Status': v.status,\n        'Amount Collected': toNum(v.amount), 'Notes': v.notes\n      });\n    });\n  });\n\n  const wb = XLSX.utils.book_new();\n  XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(billRows), 'Delivery Details');\n  XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(visitRows.length ? visitRows : [{'Note':'No collection visits logged yet'}]), 'Collection Visits');\n\n  const today = new Date().toISOString().slice(0,10);\n  XLSX.writeFile(wb, `Shree_Radhe_Ledger_Backup_${today}.xlsx`);\n  toast(`Backup downloaded — ${billRows.length} bills, ${visitRows.length} visits.`);\n});\n\ncheckAuthAndBoot();"
if js_old in content:
    content = content.replace(js_old, js_new, 1)
    changes += 1

if changes == 2:
    with open('index.html', 'w') as f:
        f.write(content)
    print("SUCCESS: backup button added.")
elif changes == 0:
    print("NOTHING MATCHED: file may already have this, or differs from expected.")
else:
    print(f"PARTIAL: only {changes} of 2 patches applied -- file NOT saved. Send this output back.")
