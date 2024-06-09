using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Soldier : MonoBehaviour
{ 
    
    [SerializeField] private GameObject soldierHoverImage;
    [SerializeField] private SoldierLine soldierLine;
    private bool isSelected;
    private bool startMoving = false;
    [SerializeField] private bool canOpenActions = false;

    [SerializeField] private UnitHealth unitsHealth;
    private void Update()
    {
        if (canOpenActions)
        {
            if (Input.GetKeyDown(KeyCode.Mouse1))
            {
                Debug.Log("RIGHT CLICK");
                Vector3 screenPos = Camera.main.WorldToScreenPoint(transform.position);
                GameManager.Instance.ActDesSoldierActions(screenPos);
            }
        }
        
        if (startMoving)
        {
            soldierLine.StartMovingFollowingTheLine();
            if (soldierLine.GetMoveEnded())
            {
                startMoving = false;
                soldierLine.alreadyDraw = false;
            }
        }
    }

    private void OnMouseEnter()
    {
        if (Manager.Instance.gamestatus == GameStatus.Playing)
        {
            if (!unitsHealth.isDead)
            {
                Debug.Log("ENTER");
                canOpenActions = true;
                isSelected = true;
                soldierHoverImage.SetActive(true);

            }
        }
    }

    private void OnMouseExit()
    {
        if (Manager.Instance.gamestatus == GameStatus.Playing)
        {
            if (!unitsHealth.isDead)
            {
                canOpenActions = false;
                isSelected = false;
                soldierHoverImage.SetActive(false);
            }
        }
    }

    private void OnMouseDrag()
    {
        if (Manager.Instance.gamestatus == GameStatus.Playing)
        {
            if (!unitsHealth.isDead)
            {
                GameManager.Instance.ClearAllSoldierStatus();
                isSelected = true;
                if (soldierLine.alreadyDraw)
                {
                    soldierLine.line.positionCount = 0;
                }
                soldierLine.DrawMovementLine();
                soldierHoverImage.SetActive(true); 
            }
        }
    }

    private void OnMouseUp()
    {
        if (Manager.Instance.gamestatus == GameStatus.Playing)
        {
            isSelected = false;
            soldierLine.alreadyDraw = !soldierLine.alreadyDraw;
            soldierHoverImage.SetActive(false);
            //Activate Movement
            startMoving = true;
        }
    }

    public void SetUnitHealtScript(UnitHealth aux)
    {
        this.unitsHealth = aux;
    }

    public void SetAvalilableSoldierActionsUI(bool aux)
    {
        this.canOpenActions = aux;
    }
}
