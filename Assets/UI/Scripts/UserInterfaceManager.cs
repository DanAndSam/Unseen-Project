using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class UserInterfaceManager : MonoBehaviour
{
    public Button attackButton;
    public Button reticuleButton;
    public Button nextAttack;
    public PlayerController playerRef;

    void Start()
    {
        reticuleButton.onClick.AddListener(() => CombatManager.Instance.LaunchReticule());
        attackButton.onClick.AddListener(() => playerRef.Attack());
    }
}
